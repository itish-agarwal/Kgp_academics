// Test to check pointer handling

int main()
{
	int *p;
	int i=5;
	p=&i;
	*p=45;
	printInt(i);
	printStr("\n");
	int *q=p;
	*q=120;
	printInt(i);
	printStr("\n");
	char c='Z';
	char *d;
	d=&c;
	*d='k';
	if(c=='k')
	{
		printStr("Test string 1\n");
	}
	else
	{
		printStr("Test string 2\n");
	}
	printInt(i);
	printStr("\n");
	
	return 0;
}
