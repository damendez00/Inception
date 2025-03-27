#!/bin/bash

# Inception Project Evaluation Script
# Checks all critical requirements from the subject

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "\n${GREEN}=== Starting Inception Project Evaluation ===${NC}\n"

# 1. Check docker-compose.yml for networks
echo -e "${GREEN}[1/5] Checking docker-compose.yml network configuration...${NC}"
if ! grep -q "networks:" srcs/docker-compose.yml; then
    echo -e "${RED}ERROR: No networks defined in docker-compose.yml${NC}"
    exit 1
else
    echo -e "✓ Networks configuration found"
fi

if grep -q "network: host" srcs/docker-compose.yml || grep -q "links:" srcs/docker-compose.yml; then
    echo -e "${RED}ERROR: Prohibited network configuration found (host or links)${NC}"
    exit 1
else
    echo -e "✓ No prohibited network configurations"
fi

# 2. Check for --link in Makefile and scripts
echo -e "\n${GREEN}[2/5] Checking for prohibited --link usage...${NC}"
if grep -r --include=Makefile --include=*.sh "--link" .; then
    echo -e "${RED}ERROR: Prohibited --link option found${NC}"
    exit 1
else
    echo -e "✓ No --link usage found"
fi

# 3. Check Dockerfiles for prohibited commands
echo -e "\n${GREEN}[3/5] Checking Dockerfiles for prohibited commands...${NC}"
BAD_PATTERNS=("tail -f" "sleep infinity" "while true" "nginx & bash" "bash$" "sh$")
FOUND_ISSUE=0

for pattern in "${BAD_PATTERNS[@]}"; do
    if grep -r -E "${pattern}" srcs/requirements/*/Dockerfile; then
        FOUND_ISSUE=1
    fi
done

if [ $FOUND_ISSUE -eq 1 ]; then
    echo -e "${RED}ERROR: Prohibited commands found in Dockerfiles${NC}"
    exit 1
else
    echo -e "✓ Dockerfiles are clean"
fi

# 4. Check entrypoint scripts for background processes
echo -e "\n${GREEN}[4/5] Checking entrypoint scripts for background processes...${NC}"
if grep -r "&" srcs/requirements/*/tools/; then
    echo -e "${RED}ERROR: Background processes (&) found in entrypoint scripts${NC}"
    exit 1
else
    echo -e "✓ No background processes in entrypoint scripts"
fi

# 5. Check for infinite loops in all scripts
echo -e "\n${GREEN}[5/5] Checking for infinite loops in scripts...${NC}"
INFINITE_LOOPS=("sleep infinity" "tail -f /dev/null" "tail -f /dev/random")
FOUND_LOOP=0

for loop in "${INFINITE_LOOPS[@]}"; do
    if grep -r -E "${loop}" srcs/; then
        FOUND_LOOP=1
    fi
done

if [ $FOUND_LOOP -eq 1 ]; then
    echo -e "${RED}ERROR: Infinite loop patterns found in scripts${NC}"
    exit 1
else
    echo -e "✓ No infinite loops found"
fi

echo -e "\n${GREEN}=== Evaluation Complete ==="
echo -e "✓ All critical checks passed successfully!${NC}"