NC='\033[0m' # No Color
YELLOW='\033[0;33m'
BLUE='\033[0;34m'

echo -e "${BLUE}Black${NC}: looking for branches..."
echo -e "${BLUE}Black${NC}: base branch is ${YELLOW}$BASE${NC}"
echo -e "${BLUE}Black${NC}: head branch is ${YELLOW}$HEAD${NC}"

echo -e "${BLUE}Black${NC}: looking for changed python files..."
python_files=$(git diff --name-only --diff-filter=duxb origin/${BASE}...origin/${HEAD} | grep -Ei '\.py$')

if [ -z "${python_files}" ]; then
    echo -e "${BLUE}Black${NC}: changed python files do not exist."
    exit 0
fi

echo -e "${BLUE}Black${NC}: check code formatting."
black --check --line-length 120 ${python_files}

if [ $? == 0 ]; then
    echo -e "${BLUE}Black${NC}: code formatting of all python files is perfect!"
    exit 0
else
    echo ""
    echo -e "${BLUE}Black${NC}: try the following to fix code formatting:"
    echo -e "  - Run '${YELLOW}black --line-length 120 \$(git diff --name-only --diff-filter=duxb origin/${BASE}...origin/${HEAD} | grep -Ei '\.py\$')${NC}'"
    echo -e "  - Look at the https://jaranda.atlassian.net/wiki/spaces/DEV/pages/4705911590/PyCharm+Formatter+Setup+Guide, set up Black in your IDE, and fix the formatting of the changed files."
    echo -e "  - Apply Black to the changed files. command: ${YELLOW}black --line-length 120 {{ changed file name }}${NC}"
    echo ""

    exit 1
fi
