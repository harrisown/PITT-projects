#include <stdio.h> 
#include <stdlib.h> 
#include <unistd.h> 
#define NODE_SIZE 16

typedef struct node{
	int occupied;
	struct node *next;
	struct node *previous;
	int allocation_size; 
}node;

void coalesce(node *ptr);

node *first;
node *last;
node *free_node;
node *new_node;
node *current;
node *before;
node *after;
node *middle;
node *conductor;
node *worst_node;
node *new_free;
node *free_pocket;
int num_nodes=0;
int biggest_worst_size = 0;

void *my_worstfit_malloc(int size){
	if(num_nodes == 0){
		first = sbrk(size + NODE_SIZE);
		first->occupied = 1;
		first->next = NULL;
		first->previous = NULL;
		first->allocation_size = size+NODE_SIZE;
		last = first;
		current = first;
		num_nodes++;
		return (void *)first + NODE_SIZE;
	
	}else{
		conductor = first;
		worst_node = NULL;
		biggest_worst_size = 0;
		free_pocket = NULL;

		while(conductor->next != NULL){
			if((conductor->occupied == 0)&& (conductor->allocation_size >= size+NODE_SIZE)&& (conductor->allocation_size > biggest_worst_size)){
				biggest_worst_size = conductor ->allocation_size;
				worst_node = conductor;
			}
			conductor = conductor->next;
		}
		if(worst_node != NULL){
			worst_node->occupied = 1;
			if((worst_node->allocation_size - (size+NODE_SIZE)) > NODE_SIZE){
				//printf("methodtest\n");
				new_free = (void *)worst_node + NODE_SIZE + size; 
				free_pocket = worst_node->next;
				worst_node->next = new_free;
				new_free->next = free_pocket;
				new_free->previous = worst_node;
				free_pocket->previous = new_free;
				new_free->occupied = 0;
				new_free->allocation_size = (worst_node->allocation_size - (size-NODE_SIZE));
				worst_node->allocation_size = size+NODE_SIZE;
				num_nodes++;
				coalesce(new_free);
			}
				

			return (void *)worst_node + NODE_SIZE;	
		}else{
			new_node = sbrk(0);
			new_node->allocation_size = size+NODE_SIZE;
			new_node->occupied = 1;
			new_node->next = NULL;
			new_node->previous = current;
			current->next = new_node;
			last = new_node;
			current = new_node;
			num_nodes++;
	
			return sbrk(size + NODE_SIZE) + NODE_SIZE;
	       } 
	}
}

void my_free(void *ptr){ 
	free_node = ptr - NODE_SIZE;
	free_node->occupied = 0;
	coalesce(free_node);
	//printf("%d is the size of the new region\n",(free_node->allocation_size));
	//printf("%d is the num_nodes\n",num_nodes);
	if(free_node->next == NULL){
		brk(free_node);
		num_nodes--;
		if(num_nodes != 0){
			last = free_node->previous;
			last->next = NULL;
		}
		return;

	}
	
	
}
	
void coalesce(node *ptr){
	//printf("test coalesce\n");
	middle  = ptr;
	before = middle->previous;
	after = middle->next;
	//printf("%p is the before address\n",before);
	//printf("%p is the after address\n",after);
	//printf("%p is the current address freed\n",ptr);
	if((before!=NULL)&&(after!=NULL)&&(before->occupied == 0) && (after->occupied == 0)){
		//printf("test1\n");
		before->next = after->next;
		if(after->next != NULL){
			(after->next)->previous = before;
		}
		before->occupied = 0;
		before->allocation_size = ((before->allocation_size)+(middle->allocation_size) + (after->allocation_size));
		free_node = before;
		num_nodes-= 2;
		return;
	}else if((before!=NULL)&&(after!=NULL)&&(before->occupied == 0)&& (after->occupied == 1)){
		//printf("test2\n");
		before->next = after;
		after->previous = before;
		before->allocation_size = ((middle->allocation_size) + (before->allocation_size));
		before->occupied =0;
		free_node = before;
		num_nodes--;
		return;
	}else if((before == NULL || before->occupied == 1)&&(after!=NULL) && (after->occupied == 0)){
		//printf("test3\n");
		middle->next = after->next;
		(after->next)->previous = middle;
		middle->allocation_size = ((ptr->allocation_size) + (after->allocation_size));
		middle->occupied =0;
		free_node = middle;
		num_nodes--;
		return;
	}else if((before != NULL)&&(before->occupied ==0)){
		//printf("test4\n");
		before->next = middle->next;
		if((middle->next)!=NULL){
			(before->next)->previous = before;
		}
	
		before->allocation_size = ((before->allocation_size) + (middle->allocation_size));
		before->occupied = 0;
		free_node = before;
		num_nodes--;
		return;
		//printf("%p is the pointer to the new free\n",free_node);
		//printf("%p is the pointer to after\n",free_node->next);
		
	}
}
