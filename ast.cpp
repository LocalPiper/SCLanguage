#include "ast.hpp"
#include <iostream>
#include <unordered_map>
#include <vector>
using namespace std;

vector<unordered_map<string, int>> scopes = {{}};

void enterScope() { scopes.push_back({}); }

void exitScope() {
  if (scopes.size() > 1) {
    scopes.pop_back();
  }
}

int getVar(const string &name) {
  for (auto it = scopes.rbegin(); it != scopes.rend(); ++it) {
    if (it->count(name))
      return (*it)[name];
  }
  cerr << "Error: Undefined variable " << name << endl;
  return 0;
}

void setVar(const string &name, int value) { scopes.back()[name] = value; }

int VariableNode::evaluate() const { return getVar(name); }

int BinaryOpNode::evaluate() const {
  int leftVal = left->evaluate();
  int rightVal = right->evaluate();

  if (op == "+") {
    return leftVal + rightVal;
  } else if (op == "-") {
    return leftVal - rightVal;
  } else if (op == "*") {
    return leftVal * rightVal;
  } else if (op == "/") {
    return leftVal / rightVal;
  } else if (op == ">") {
    return leftVal > rightVal;
  } else if (op == "<") {
    return leftVal < rightVal;
  } else if (op == ">=") {
    return leftVal >= rightVal;
  } else if (op == "<=") {
    return leftVal <= rightVal;
  } else if (op == "==") {
    return leftVal == rightVal;
  } else if (op == "!=") {
    return leftVal != rightVal;
  } else if (op == "||") {
    return leftVal || rightVal;
  } else if (op == "&&") {
    return leftVal && rightVal;
  }
  cerr << "Error: Unknown operator " << op << endl;
  return 0;
}

int UnaryOpNode::evaluate() const {
  int result = right->evaluate();

  if (op == "-") {
    return -result;
  } else if (op == "!") {
    return !result;
  }
  cerr << "Error: Unknown operator " << op << endl;
  return 0;
}

int PrintNode::evaluate() const {
  int result = expression->evaluate();
  cout << "Milord proclaimeth: " << result << "!\n";
  return result;
}

int AssignmentNode::evaluate() const {
  int result = expression->evaluate();
  setVar(name, result);
  return result;
}

int IfNode::evaluate() const {
  if (condition->evaluate()) {
    return thenBlock->evaluate();
  } else if (elseBlock) {
    return elseBlock->evaluate();
  }
  return 0;
}

int BlockNode::evaluate() const {
  enterScope();
  int result = 0;
  for (auto &statement : statements) {
    result = statement->evaluate();
  }
  exitScope();
  return result;
}
