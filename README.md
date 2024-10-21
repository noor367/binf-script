# binf-script
A bash shell script written for an 'Introduction To Bioinformatics' course's assignment.

## The Task

Write	a	bash	shell	script	that	retrieves	all	the	reviewed	mammalian	protein	sequences	from	UniprotKB	that	correspond	to	a	specific	gene	name	(specified	as	
argument	1	when	running	the	script)	then	creates	a	multiple	sequence	alignment	out	of	these	sequences	then	builds	a	phylogenetic	tree	from	this	multiple	
sequence	alignment.	
• Your	submission	should	consist	of	one	file	named	uniTree.sh	
• The	script	should	be	invoked	using	the	command	./uniTree.sh GENE	
where	GENE	is	a	gene	code	in	UniprotKB,	found	in	the	Gene	name	[GN]	field.	Example	gene	names	include	INS	and	EGF.		

The	output	of	the	script	should	be	a	phylogenetic	tree	file	in	Newick	format (nested	parentheses)	suitable	for	input	into	a	tree	visualisation	program	such	as	
Dendroscope.	The	file	should	be	named	GENE.tree	(where	GENE	is	the	gene name	specified	at	the	command	line).	The	leaves	of	the	tree	should	be	labelled	with	only	the	species	name	as	much	as	the	program	allows	you	to	(in	some	cases	 you	may	get	multiple	proteins	from	the	same	species	in	which	case	you	may	need	
to	add	a	number	to	the	name	in	the	tree).	An	example	output	for	EGF	is	on	 Moodle.	However,	note	that	because	the	databases	are	constantly	updated,	the	 example	output	may	not	be	exactly	as	your	program	will	generate	it.	

The	script	should	perform	the	following	suggested	steps:	
- Retrieve	from	UniprotKB	all	the	sequences	with	the	specified	gene	 name	in	their	GN	field	that	also	are	of	Mammalian	origin	(field	OC=	 Mammalia	[40674])	and	have	been	reviewed	for	inclusion	into SwissProt	(field	Reviewed	set	to	Yes).	The	sequences	should	be	retrieved	in	one	file	in	fasta	format.	You	probably	will	need	to	
make	use	of	the	Uniprot	RESTful	API	
(http://www.uniprot.org/help/programmatic_access)	for	this,	together	with	the	UNIX	command	wget.	
- Edit	the	header	of	the	fasta	sequences	so	that	they	contain	only	the	 species	name.	If	there	are	multiple	sequences	from	the	same	 species	(for	example	a	protein	with	multiple	isoforms)	you	can	add	 a	number	to	the	species	name	–	eg	Mus	musculus1	and	Mus	musculus2.		
- Run	a	multiple	sequence	alignment	program	(eg	clustalw)	to align	the	sequences	and	create	a	multiple	sequence	alignment	
- Run	another	program	to	build	a	phylogenetic	tree	out	of	the	multiple	sequence	alignment.	Clustalw	with	the	–tree	option	is probably	the	easiest	option	for	this	as phylip	programs	are	quite	tricky	to	script	and	require	writing	a	“batch	file”	(but	do	not	simply	use	the	clustalw	guide	tree	created	during	multiple	sequence	 alignment	(.dnd	file)	as	the	tree	as	it	is	not	a	true	phylogenetic tree).	
- Rename	the	tree	file	if	necessary.	
- Delete	any	intermediary	files	created	by	the	script,	keeping	only the	final	tree	output	(and	any	other	files	that	were	already	there	when	you	started	the	program).
