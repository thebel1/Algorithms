#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define CRASH() ({ asm volatile ("ud2"); })

#define SERIAL_STR_MAX_LEN 256

struct TreeNode {
   struct TreeNode *left;
   struct TreeNode *right;
   int val;
};

void
newNode(struct TreeNode **node, int val)
{
   (*node) = malloc(sizeof(*node));
   (*node)->left = NULL;
   (*node)->right = NULL;
   (*node)->val = val;
}

void
treeInsert(struct TreeNode **root, int val)
{
   struct TreeNode **node;
   int cur;

   if (*root == NULL) {
      newNode(root, val);
      return;
   }

   node = root;
   while (*node != NULL) {
      cur = (*node)->val;
      if (val < cur) {
         node = &(*node)->left;
      }
      else {
         node = &(*node)->right;
      }
   }

   newNode(node, val);
}

void
treeDelete(struct TreeNode *root, int val)
{
   struct TreeNode *node;
   int cur;

   if (root == NULL) {
      return;
   }

   node = root;
   while (node != NULL && node->val != val) {
      cur = node->val;
      if (val < cur) {
         node = node->left;
      }
      else if (val > cur) {
         node = node->right;
      }
      else {
         freeTree(node);
      }
   }
}

void
freeTree(struct TreeNode *node)
{
   if (node == NULL) {
      return;
   }

   if (node->left == NULL && node->right == NULL) {
      free(node);
   }
   else {
      freeTree(node->left);
      freeTree(node->right);
      free(node);
   }
}

int
main(int argc, char **argv)
{
   struct TreeNode *root = NULL;
   int i, val;

   if (argc < 2) {
      printf("Must supply an array of values\n");
      exit(1);
   }

   for (i = 0; i < argc - 1; ++i) {
      val = atoi(argv[i + 1]);
      treeInsert(&root, val);
   }

   //CRASH();

   freeTree(root);

   return 0;
}