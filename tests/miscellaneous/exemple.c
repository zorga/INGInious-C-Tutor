#include <stdlib.h>
#include "thesis_LinkedList.h"

int main (int argc, char** argv)
{
  node_t* aNode = (node_t*) malloc (sizeof (node_t));
  aNode->data = 42;
  aNode->next = NULL;
  free(aNode);
  aNode->data = 34;
  return 0;
}

