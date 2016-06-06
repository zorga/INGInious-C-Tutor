#include <stdlib.h>
#include <stdio.h>

int main (int argc, char** argv)
{
  int i; // Uninitialized!
  while (i < 2)
  {
    printf("I use an uninitiazed variable i : %d\n", i);
    i++;
  }
  return 0;
}

