#!/bin/bash

# 🔒 SECURITY AUDIT: GitHub Actions Workflow Validation
# This script audits all GitHub Actions workflows for security vulnerabilities

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔒 Starting GitHub Actions Security Audit...${NC}"
echo ""

WORKFLOW_DIR=".github/workflows"
ISSUES_FOUND=0

# Function to check workflow security
check_workflow_security() {
    local workflow_file="$1"
    local workflow_name=$(basename "$workflow_file" .yml)
    
    echo -e "${BLUE}🔍 Auditing: ${workflow_name}${NC}"
    
    # Check if workflow has proper triggers
    if grep -q "pull_request:" "$workflow_file"; then
        if ! grep -q "workflow_run:" "$workflow_file" && [[ "$workflow_name" != "ci-pull-request" ]]; then
            echo -e "  ${RED}❌ CRITICAL: Workflow can be triggered by PRs without validation${NC}"
            ((ISSUES_FOUND++))
        fi
    fi
    
    # Check for push triggers on deployment workflows
    if [[ "$workflow_name" == *"deploy"* ]] || [[ "$workflow_name" == *"sync"* ]]; then
        if grep -q "push:" "$workflow_file" && ! grep -q "workflow_run:" "$workflow_file"; then
            echo -e "  ${RED}❌ CRITICAL: Deployment workflow triggered by push without validation${NC}"
            ((ISSUES_FOUND++))
        fi
    fi
    
    # Check for proper validation dependencies
    if grep -q "workflow_run:" "$workflow_file"; then
        if grep -q "check-validation:" "$workflow_file"; then
            echo -e "  ${GREEN}✅ Has validation check job${NC}"
        else
            echo -e "  ${YELLOW}⚠️  Warning: Has workflow_run trigger but no validation check${NC}"
        fi
        
        if grep -q "needs: check-validation" "$workflow_file"; then
            echo -e "  ${GREEN}✅ Jobs depend on validation${NC}"
        else
            echo -e "  ${RED}❌ CRITICAL: Jobs don't depend on validation check${NC}"
            ((ISSUES_FOUND++))
        fi
    fi
    
    # Check for emergency bypass options
    if grep -q "bypass_validation" "$workflow_file"; then
        echo -e "  ${YELLOW}⚠️  Has emergency bypass option (review usage)${NC}"
    fi
    
    # Check permissions
    if grep -q "permissions:" "$workflow_file"; then
        if grep -q "contents: write" "$workflow_file"; then
            echo -e "  ${YELLOW}⚠️  Has write permissions (verify necessity)${NC}"
        fi
    else
        echo -e "  ${YELLOW}⚠️  No explicit permissions set${NC}"
    fi
    
    echo ""
}

# Check if workflows directory exists
if [ ! -d "$WORKFLOW_DIR" ]; then
    echo -e "${RED}❌ No .github/workflows directory found${NC}"
    exit 1
fi

# Audit all workflow files
for workflow in "$WORKFLOW_DIR"/*.yml "$WORKFLOW_DIR"/*.yaml; do
    if [ -f "$workflow" ]; then
        check_workflow_security "$workflow"
    fi
done

echo -e "${BLUE}📊 Security Audit Summary${NC}"
echo "=================================="

if [ $ISSUES_FOUND -eq 0 ]; then
    echo -e "${GREEN}✅ No critical security issues found!${NC}"
    echo -e "${GREEN}🎉 All workflows appear to be properly secured${NC}"
else
    echo -e "${RED}❌ Found $ISSUES_FOUND critical security issue(s)${NC}"
    echo -e "${RED}🚨 IMMEDIATE ACTION REQUIRED${NC}"
fi

echo ""
echo -e "${BLUE}🔒 Security Best Practices Check:${NC}"

# Check for branch protection indicators
if [ -f "BRANCH-PROTECTION-SETUP.md" ]; then
    echo -e "${GREEN}✅ Branch protection documentation exists${NC}"
else
    echo -e "${YELLOW}⚠️  No branch protection documentation found${NC}"
fi

# Check for security documentation
if [ -f "WORKFLOW-SECURITY-AUDIT.md" ]; then
    echo -e "${GREEN}✅ Workflow security documentation exists${NC}"
else
    echo -e "${YELLOW}⚠️  No workflow security documentation found${NC}"
fi

# Check CI/CD workflow exists
if [ -f ".github/workflows/ci-pull-request.yml" ]; then
    echo -e "${GREEN}✅ CI/CD validation workflow exists${NC}"
else
    echo -e "${RED}❌ No CI/CD validation workflow found${NC}"
    ((ISSUES_FOUND++))
fi

echo ""
echo -e "${BLUE}🛡️  Recommended Actions:${NC}"
echo "1. Enable branch protection on main branch"
echo "2. Require PR reviews before merging"
echo "3. Require status checks to pass"
echo "4. Restrict pushes to main branch"
echo "5. Monitor workflow runs for suspicious activity"

exit $ISSUES_FOUND
