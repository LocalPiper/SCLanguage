#ifndef AST_HPP
#define AST_HPP

#include <string>
#include <vector>

using namespace std;

class ASTNode {
public:
  virtual ~ASTNode() = default;
  virtual int evaluate() const = 0;
};

class NumberNode : public ASTNode {
public:
  int value;
  NumberNode(int val) : value(val) {}
  int evaluate() const override { return value; }
};

class VariableNode : public ASTNode {
public:
  string name;
  VariableNode(const string &n) : name(n) {}
  int evaluate() const override;
};

class BinaryOpNode : public ASTNode {
public:
  string op;
  ASTNode *left;
  ASTNode *right;

  BinaryOpNode(const string &o, ASTNode *l, ASTNode *r)
      : op(o), left(l), right(r) {}

  int evaluate() const override;
};

class UnaryOpNode : public ASTNode {
public:
  string op;
  ASTNode *right;

  UnaryOpNode(const string &o, ASTNode *r) : op(o), right(r) {}

  int evaluate() const override;
};

class PrintNode : public ASTNode {
public:
  ASTNode *expression;
  PrintNode(ASTNode *expr) : expression(expr) {}
  int evaluate() const override;
};

class AssignmentNode : public ASTNode {
public:
  string name;
  ASTNode *expression;
  AssignmentNode(const string &n, ASTNode *expr) : name(n), expression(expr) {}
  int evaluate() const override;
};

class IfNode : public ASTNode {
public:
  ASTNode *condition;
  ASTNode *thenBlock;
  ASTNode *elseBlock;
  IfNode(ASTNode *cond, ASTNode *thenB, ASTNode *elseB = nullptr)
      : condition(cond), thenBlock(thenB), elseBlock(elseB) {}
  int evaluate() const override;
};

class BlockNode : public ASTNode {
public:
  vector<ASTNode *> statements;
  void addStatement(ASTNode *stmt) { statements.push_back(stmt); }
  int evaluate() const override;
};

#endif // AST_HPP
