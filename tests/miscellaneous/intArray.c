/*
* Author : Nicolas Ooghe
* Test program for my thesis
*/

#include <stdlib.h>
#include <stdio.h>
#include <errno.h>

#define ARRAY_SIZE  (8)

int printArray (int* ar, int len)
{
  if (!ar)
  {
    fprintf (stderr, "Errno value : %d\n", errno);
    perror ("Uninitialized array\n");
    return -1;
  }
  int i = 0;
  while (i < len)
  {
    printf ("Element %d : %d\n", i, (int) *(ar + i));
    i++;
  } 

  return 0;
}

int main (int argc, char** argv)
{
  int* array = (int*) malloc (ARRAY_SIZE * sizeof (int));

  int i = 0;

  while (i < ARRAY_SIZE)
  {
    *(array + i) = (i + 5) * 3;
    i++;
  }

  int len = sizeof (array);

  printArray (array, len);
  free (array);
  array = NULL;

  *(array + 90) = 42; // Segfault !

  return 0;
}

