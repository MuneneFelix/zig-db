#The intention is to use concepts presented in this book to implement a db to store my TODOS for ease of learning

#Inspired by Software Internals group organized by Phil Eaton

of Importance are the two concepts of storage and distribution.

#PART 1 --STORAGE
B-trees -balancing -logarithmic lookup complexity when balanced  O(log2N)
when inbalanced worst case complexity becomes O(N)

tree is balanced after each operation. Balancing is done by minimizng tree height and keeping the number of nodes within bounds
one way of doing this is by adding a rotational step after the insert operation leaves a tree unbalanced (2 consecutive nodes in a branch have only one node)
so during rotation, the middle node (rotation pivot) is promoted one level higher and it's parent becomes it's right child

BST are impractical as on-disk data structures due to the operations needed to optimize lookup complexity i.e balancing,relocating nodes and updating pointers

Another common problem is locality. Since elements are added in random order, there's no guarantee that a newly added node is close to its parents, which means that child node pointers may span several disk pages.

A data structure suitable for disk storage needs the following properties
    -High fanout to imporve locality of the neighbouring keys
    -Low height to reduce the number of seeks during traversal
    