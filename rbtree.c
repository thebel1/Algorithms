#include <stdlib.h>
#include <stdio.h>

enum RBCol {
   RED = 0,
   BLACK = 1,
};

struct RBNode {
   struct RBNode *parent;
   struct RBNode *left;
   struct RBNode *right;
   enum RBCol color;
   int val;
};

void
newRBNode(struct RBNode **node,
          struct RBNode *parent,
          int val)
{
   *node = malloc(sizeof(**node));
   (*node)->parent = parent;
   (*node)->left = NULL;
   (*node)->right = NULL;
   (*node)->color = BLACK;
   (*node)->val = val;
}

/*void
rbTreeInsertFixup(struct RBNode *node)
{
   struct RBNode *tmp;

   if (node->parent == NULL) {
      node->color = BLACK;
      return;
   }

   while (node->parent->color == RED) {
      if (node->parent->parent == NULL) {
         break;
      }

      if (node->parent == node->parent->parent->left) {
         tmp = node->parent->parent->right;
         if (tmp->color == RED) {
            node->parent->color = BLACK;
            tmp->color = BLACK;
            node->parent->parent->color = RED;
            node = node->parent->parent;
         }
         else if (node == node->parent->right) {

         }
      }
   }
}*/

void
rbTreeInsert(struct RBNode **root, int val)
{
   struct RBNode **node, *parent;
   int cur;

   if (*root == NULL) {
      newRBNode(root, NULL, val);
      return;
   }

   node = root;
   while (*node != NULL) {
      cur = (*node)->val;
      if (val < cur) {
         parent = *node;
         node = &(*node)->left;
      }
      else {
         parent = *node;
         node = &(*node)->right;
      }
   }

   newRBNode(node, parent, val);
   //rbTreeInsertFixup(*node);
}

int
main()
{

   return 0;
}