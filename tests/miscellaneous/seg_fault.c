#include <stdlib.h>
#include "thesis_LinkedList.h"

int main (int argc, char** argv)
{
  // initialize linked list with only one node
  node_t* aNode = init(50);
  // next node is 'NULL'
  aNode->next->data = 8; // Error!
  return 0;
}

  
