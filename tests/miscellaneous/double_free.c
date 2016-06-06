#include <stdlib.h>
#include "thesis_LinkedList.h"

int main (int argc, char** argv)
{
  node_t* pNode = (node_t*) malloc (sizeof (node_t));
  free (pNode);
  free (pNode); // free an already freed variable!
  return 0;
}
  
