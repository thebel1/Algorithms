#include <stdlib.h>
#include <stdio.h>
#include <string.h>

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

char *
serialize(struct TreeNode *node, char *out)
{

   if (node == NULL) {
      out += sprintf(out, "%d ", -1);
      return out;
   }

   out += sprintf(out, "%d ", node->val);
   out = serialize(node->left, out);
   out = serialize(node->right, out);

   return out;
}

int
deserialize(struct TreeNode **node, int *arr, int idx, int size)
{
   if (idx >= size || arr[idx] == -1) {
      return idx;
   }

   newNode(node, arr[idx]);

   idx = deserialize(&(*node)->left, arr, idx + 1, size);
   idx = deserialize(&(*node)->left, arr, idx + 1, size);

   return idx;
}

int
main(int argc, char **argv)
{
   struct TreeNode *root = NULL;
   int *arr;
   int size, i;
   char *out;

   if (argc < 2) {
      printf("Must supply an array of values\n");
      exit(1);
   }

   size = argc - 1;
   arr = malloc(size * sizeof(*arr));

   for (i = 0; i < size; ++i) {
      arr[i] = atoi(argv[i + 1]);
   }

   out = malloc(SERIAL_STR_MAX_LEN);
   memset(out, 0, SERIAL_STR_MAX_LEN);

   deserialize(&root, arr, 0, size);
   serialize(root, out);

   printf("%s\n", out);

   free(arr);

   return 0;
}