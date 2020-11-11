#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <limits.h>

#define MIN(a, b) (a > b ? b : a)
#define MAX(a, b) (a < b ? b : a)

int
cutRod(int *prices, int length, int *optLengths)
{
   int revenue, tmp, i;

   if (length == 0) {
      return 0;
   }

   revenue = INT_MIN;

   for (i = 0; i < length; ++i) {
      tmp = prices[i] + cutRod(prices, length - 1, optLengths);
      if (tmp > revenue) {
         revenue = tmp;
         *optLengths = i;
      }
   }

   return revenue;
}

int
main(int argc, char **argv)
{
   int *arr;
   int size, i;
   int optLengths;

   if (argc < 3) {
      printf(">:(\n");
      exit(1);
   }

   size = argc - 1;
   arr = malloc(size * sizeof(*arr));

   for (i = 0; i < size; ++i) {
      arr[i] = atoi(argv[i + 1]);
   }

   printf("%d %d\n", cutRod(&arr[1], arr[0], &optLengths), optLengths);

   free(arr);

   return 0;
}