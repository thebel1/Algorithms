#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <math.h>

#define HASH_TBL_SIZE   (1<<8)
#define HASH_CONST      ((sqrt(5) - 1) / 2)

int hashTbl[HASH_TBL_SIZE];

void
initHashTbl()
{
   memset(&hashTbl, -1, sizeof(hashTbl));
}

uint32_t
getHash(int k)
{
   uint32_t out;

   out = (uint32_t)(HASH_TBL_SIZE * (uint32_t)(k * HASH_CONST));

   return out;
}

uint32_t
getProbeHash(int k, int i)
{
   return (getHash(k) + i) % HASH_TBL_SIZE;
}

uint32_t
hashInsert(int val)
{
   uint32_t key;
   int i;

   if (val < 0) {
      return -1;
   }

   i = 0;
   do {
      key = getProbeHash(val, i);
      if (hashTbl[key] == -1) {
         hashTbl[key] = val;
         return key;
      }
      ++i;
   } while (i < HASH_TBL_SIZE);

   return -1;
}

void
printHashTbl()
{
   int i;

   for (i = 0; i < HASH_TBL_SIZE; ++i) {
      printf("%d ", hashTbl[i]);
   }
   printf("\n");
}

int
main(int argc, char **argv)
{
   int i, key;

   if (argc < 2) {
      printf("Must supply array of values\n");
      exit(1);
   }

   initHashTbl();

   for (i = 1; i < argc; ++i) {
      key = hashInsert(atoi(argv[i]));
      printf("%d ", key);
      if (key == -1) {
         printf("\nHash table full\n");
         break;
      }
   }
   printf("\n");

   printHashTbl();

   return 0;
}