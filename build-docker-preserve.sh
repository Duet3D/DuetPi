#!/usr/bin/env bash
# Note: Avoid usage of arrays as MacOS users have an older version of bash (v3.x) which does not supports arrays
set -eu

DIR="$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)"

BUILD_OPTS="$*"

DOCKER=${DOCKER:-docker}

if \
  ! ${DOCKER} ps    >/dev/null 2>&1 || \
    ${DOCKER} info 2>/dev/null | grep -q rootless \
; then
	DOCKER="sudo ${DOCKER}"
fi
if ! ${DOCKER} ps >/dev/null; then
	echo "error connecting to docker:"
	${DOCKER} ps
	exit 1
fi

CONFIG_FILE=""
if [ -f "${DIR}/config" ]; then
	CONFIG_FILE="${DIR}/config"
fi

while getopts "c:" flag; do
	case "${flag}" in
		c) CONFIG_FILE="${OPTARG}" ;;
		*) ;;
	esac
done

if test -x /usr/bin/realpath; then
	CONFIG_FILE=$(realpath -s "$CONFIG_FILE" || realpath "$CONFIG_FILE")
fi

if test -z "${CONFIG_FILE}"; then
	echo "Configuration file must be present in '${DIR}/config' or passed as parameter"
	exit 1
else
	source "${CONFIG_FILE}"
fi

CONTAINER_NAME=${CONTAINER_NAME:-pigen_work}
CONTINUE=${CONTINUE:-0}
PRESERVE_CONTAINER=${PRESERVE_CONTAINER:-0}
PIGEN_DOCKER_OPTS=${PIGEN_DOCKER_OPTS:-""}

if [ -z "${IMG_NAME}" ]; then
	echo "IMG_NAME not set in config"
	exit 1
fi

GIT_HASH=${GIT_HASH:-"$(git rev-parse HEAD)"}

CONTAINER_EXISTS=$(${DOCKER} ps -a --filter name="^${CONTAINER_NAME}$" -q)
CONTAINER_RUNNING=$(${DOCKER} ps --filter name="^${CONTAINER_NAME}$" -q)

if [ -n "${CONTAINER_RUNNING}" ]; then
	echo "The build is already running in container ${CONTAINER_NAME}. Aborting."
	exit 1
fi

if [ -n "${CONTAINER_EXISTS}" ] && [ "${CONTINUE}" != "1" ]; then
	echo "Container ${CONTAINER_NAME} already exists and you did not specify CONTINUE=1. Aborting."
	echo "You can delete the existing container like this:"
	echo "  ${DOCKER} rm -v ${CONTAINER_NAME}"
	exit 1
fi

# Clean temp container from previous run if needed
TEMP_CONTAINER="${CONTAINER_NAME}_cont"
if [ "${CONTINUE}" == "1" ] && ${DOCKER} ps -a --format '{{.Names}}' | grep -q "^${TEMP_CONTAINER}$"; then
	echo "Removing leftover container ${TEMP_CONTAINER}"
	${DOCKER} rm -v "${TEMP_CONTAINER}"
fi

BUILD_OPTS="$(echo "${BUILD_OPTS:-}" | sed -E 's@\-c\s?([^ ]+)@-c /config@')"

case "$(uname -m)" in
	x86_64|aarch64) BASE_IMAGE=i386/debian:bullseye ;;
	*)              BASE_IMAGE=debian:bullseye     ;;
esac

${DOCKER} build --build-arg BASE_IMAGE=${BASE_IMAGE} -t pi-gen "${DIR}"

if [ -n "${CONTAINER_EXISTS}" ]; then
	DOCKER_CMDLINE_NAME="${CONTAINER_NAME}_cont"
	if [ "${PRESERVE_CONTAINER}" != "1" ]; then
		DOCKER_CMDLINE_PRE="--rm"
	else
		DOCKER_CMDLINE_PRE=""
	fi
	DOCKER_CMDLINE_POST="--volumes-from=${CONTAINER_NAME}"
else
	DOCKER_CMDLINE_NAME="${CONTAINER_NAME}"
	DOCKER_CMDLINE_PRE=""
	DOCKER_CMDLINE_POST=""
fi

binfmt_misc_required=1
case $(uname -m) in
	aarch64|arm*) binfmt_misc_required=0 ;;
esac

if [[ "${binfmt_misc_required}" == "1" ]]; then
	if ! qemu_arm=$(which qemu-arm-static); then
		echo "qemu-arm-static not found (please install qemu-user-static)"
		exit 1
	fi
	if [ ! -f /proc/sys/fs/binfmt_misc/register ]; then
		echo "binfmt_misc required but not mounted, trying to mount..."
		if ! mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc; then
			echo "mounting binfmt_misc failed"
			exit 1
		fi
	fi
	if ! grep -q "^interpreter ${qemu_arm}" /proc/sys/fs/binfmt_misc/qemu-arm*; then
		reg="echo ':qemu-arm-rpi:M::\
\x7fELF\x01\x01\x01\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x28\x00:\
\xff\xff\xff\xff\xff\xff\xff\x00\xff\xff\xff\xff\xff\xff\xff\xff\xfe\xff\xff\xff:\
${qemu_arm}:F' > /proc/sys/fs/binfmt_misc/register"
		echo "Registering qemu-arm for binfmt_misc..."
		sudo bash -c "${reg}" 2>/dev/null || true
	fi
fi

trap 'echo "got CTRL+C... please wait 5s" && ${DOCKER} stop -t 5 ${DOCKER_CMDLINE_NAME}' SIGINT SIGTERM

time ${DOCKER} run \
	${DOCKER_CMDLINE_PRE} \
	--name "${DOCKER_CMDLINE_NAME}" \
	--privileged \
	${PIGEN_DOCKER_OPTS} \
	--volume "${CONFIG_FILE}":/config:ro \
	-e "GIT_HASH=${GIT_HASH}" \
	${DOCKER_CMDLINE_POST} \
	pi-gen \
	bash -e -o pipefail -c "
		dpkg-reconfigure qemu-user-static &&
		(mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc || true) &&
		cd /pi-gen; ./build.sh ${BUILD_OPTS} &&
		rsync -av work/*/build.log deploy/
	" &
wait "$!"

echo "copying results from deploy/"
${DOCKER} cp "${CONTAINER_NAME}":/pi-gen/deploy - | tar -xf -

echo "copying log from container ${CONTAINER_NAME} to deploy/"
${DOCKER} logs --timestamps "${CONTAINER_NAME}" &>deploy/build-docker.log

ls -lah deploy

if [ "${PRESERVE_CONTAINER}" != "1" ]; then
	${DOCKER} rm -v "${CONTAINER_NAME}"
fi

echo "Done! Your image(s) should be in deploy/"
