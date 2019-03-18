"
Todo -
	Allow to the job to receive arguments. 
	
	Implement a task that responds to a composite (meaning, tasks that can be runned at the same time. cooking the sauce while working the dough).
	Define how does a complex task merges all the output into one general output. 
	Define how a complex composite task dispatches the arguments to the sub tasks. 
	Track down how many arguments needs a task. (A regular task may need as much arguments as the block that it uses)
	Test test test
	move run method to a MooseTaskRunner class. 

	Nowadays, the result of the execution of a task is beign stored in the context variable (dictionary) on the method run of the class mooseJob. 
	Change this behavior to store the result of the task into the related taskruntime object. 
	Modify the variable context of task runtime to be named ""input"". Context is to vague.
	After, ensure to cache the ""last used input"", 
	Now we can do some improvements by executing the actual task, only when the given input differs with the last input. 
	This last behaviours needs much testing. 
	
	Modify the UI for: 
		1 allowing the job to receive arguments. 
		2 display the job's output. (or allow to inspect it)
		3 reuse the job many times instead of using allways a new one (this will allow us to *really* use the cached result mechanism )
		4 allow from the ui to mark as "" to re-execute "" one or many tasks 
		
		
"
Class {
	#name : #MooseTaskBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list',
		'listPresenter',
		'saveButton',
		'loadButton',
		'addButton',
		'upButton',
		'downButton',
		'runButton',
		'state',
		'taskRepo',
		'repositoryView',
		'runner'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #specs }
MooseTaskBrowser class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #loadButton;
				add: #saveButton;
				add: #addButton ]
			height: self toolbarHeight;
		newRow: [ :row | 
			row
				add: #listPresenter;
				newColumn: [ :col | 
					col
						add: #upButton;
						add: #downButton ]
					width: self defaultFont height + 6 ];
		newRow: [ :row | row add: #runButton ] height: self toolbarHeight;
		yourself
]

{ #category : #specs }
MooseTaskBrowser class >> example [
	<example>
	| task taskRepo test gitName urlString startOIDString endOIDString |
	gitName := 'FactoryVariants'.
	urlString := 'https://github.com/fuhrmanator/FactoryVariants'.
	startOIDString := 'HEAD'.
	endOIDString := ''.
	taskRepo := MooseTaskRepository new.
	task := MooseCustomTask new
		with: [ :v | 
			| loc |
			loc := GMUtility cloneRepo: urlString ]
		description: '1 Clone Repository'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| output |
			output := GMUtility
				filterCommitsOnRepoLeftBranchOnly: v context
				from: startOIDString
				to: endOIDString.
			Array with: v context with: output ]
		description: '2 Filter Commits On Repository Left Branch'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| output |
			output := GMUtility generateSelectedCommits: v context second.
			Array with: v context first with: output ]
		description: '3 Generate Selected Commits'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| output |
			output := GMUtility generatePairsAndTransactions: v context second.
			Array with: v context first with: output ]
		description: '4 Generate Pairs And Transactions'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| output |
			output := GMUtility
				generateMSEFileFor: startOIDString
				reponame: v context first basename.
			Array with: v context second with: output ]
		description: '5 Generate MSE File For StartOID'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			GMUtility generateClientImplementationPairs: v context second.
			v context first ]
		description: '6 Generate ClientImplementation Pairs'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			GMUtility
				calculateCouplingIntersectionsFor: gitName
				withPairsFile: v context first
				from: startOIDString
				to: endOIDString ]
		description: '7 Calculate Coupling Intersections'
		length: 0.
	taskRepo addTask: task.
	test := MooseTaskBrowser new.
	test repositoryView setList: taskRepo tasks.
	test openWithSpec
]

{ #category : #specs }
MooseTaskBrowser class >> example2 [
	<example>
	| requestUrl clone taskRepo test gitName urlString startOIDString endOIDString |
	gitName := 'FactoryVariants'.
	startOIDString := 'HEAD'.
	endOIDString := ''.
	taskRepo := MooseTaskRepository new.
	requestUrl := MooseCustomTask new
		with: [ :v | 
			| loc |
			loc := UIManager default
				request: 'Please insert the url to clone'
				initialAnswer: 'https://github.com/fuhrmanator/FactoryVariants' ]
		description: '0 prompt url'
		length: 0.
	taskRepo addTask: requestUrl.
	clone := MooseCustomTask new
		with: [ :v | GMUtility cloneRepo: (v context at: v dependancies anyOne) ]
		description: '1 Clone Repository'
		length: 0.
	taskRepo addTask: clone.
	test := MooseTaskBrowser new.
	test repositoryView setList: taskRepo tasks.
	test openWithSpec
]

{ #category : #menu }
MooseTaskBrowser class >> menuMooseTask: aBuilder [
	<contextMenu>
	<mooseTaskListMenu>
	(aBuilder item: #Inspect)
		icon: (self iconNamed: #smallInspectIt);
		keyText: 'i';
		selector: #inspectTask.
	(aBuilder item: #Delete)
		icon: (self iconNamed: #delete);
		keyText: 'd';
		selector: #deleteTask
]

{ #category : #api }
MooseTaskBrowser >> aboutText [
	^ 'Moose Task Browser'
]

{ #category : #accessing }
MooseTaskBrowser >> addButton [
	^ addButton
]

{ #category : #'list control' }
MooseTaskBrowser >> deleteTask [
	list removeAt: listPresenter selectedIndex.
	listPresenter items: list.
]

{ #category : #accessing }
MooseTaskBrowser >> downButton [
	^ downButton
]

{ #category : #shortcuts }
MooseTaskBrowser >> ensureKeyBindingsFor: aWidget [
	super ensureKeyBindingsFor: aWidget.
	self registerMooseTaskListShortcuts: listPresenter
]

{ #category : #api }
MooseTaskBrowser >> extent [
	^ 350 @ 450
]

{ #category : #initialization }
MooseTaskBrowser >> initialize [
	super initialize.
		runner := MooseTaskRunner new
]

{ #category : #initialization }
MooseTaskBrowser >> initializePresenter [
	listPresenter
		whenSelectedItemChanged: [ :item | 
			| size |
			size := listPresenter listSize.
			self isRunning
				ifTrue: [ runButton disable.
						upButton disable.
						downButton disable ];
				ifFalse: [ item
							ifNil: [ runButton disable.
								upButton disable.
								downButton disable ]
							ifNotNil: [ runButton enable.
								size > 1
									ifTrue: [ upButton enable.
										downButton enable.
										listPresenter getIndex = 1
											ifTrue: [ upButton disable ].
										listPresenter getIndex = size
											ifTrue: [ downButton disable ] ] ] ] ].
	upButton action: [ self swapItems: -2 ].
	downButton action: [ self swapItems: 0 ].
	runButton
		action: [ state := true.
			runButton disable.
			self run
				ifFalse: [ self inform: 'Tasks stop.'.
					runButton enable ]
				ifTrue: [ self inform: 'Tasks finish.' ].
			state := false ].
	addButton
		action: [ repositoryView openDialogWithSpec
				okAction: [ self
						setTasks:
							(repositoryView listPresenter selectedItems asOrderedCollection
								sort: [ :a :b | a description <= b description ]) ].
			repositoryView listPresenter resetSelection ]
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWidgets [
	listPresenter := self newList.
	listPresenter
		menu: [ :menu :shifted | self mooseTaskListMenu: menu shifted: shifted ].
	loadButton := self newButton
		label: 'Load';
		icon: (self iconNamed: #smallOpen).
	saveButton := self newButton
		label: 'Save';
		icon: (self iconNamed: #glamorousSave).
	addButton := self newButton
		label: 'Add';
		icon: (self iconNamed: #smallAdd).
	upButton := self newButton icon: (self iconNamed: #up).
	downButton := self newButton icon: (self iconNamed: #down).
	runButton := self newButton
		label: 'Run';
		icon: (self iconNamed: #smallDoIt).
	repositoryView := MooseTaskRepositoryView new.
	state := false.
	self focusOrder
		add: loadButton;
		add: saveButton;
		add: addButton;
		add: upButton;
		add: downButton;
		add: listPresenter;
		add: runButton
]

{ #category : #'list control' }
MooseTaskBrowser >> inspectTask [
	listPresenter selectedItem inspect
]

{ #category : #accessing }
MooseTaskBrowser >> isRunning [
	^state 
]

{ #category : #accessing }
MooseTaskBrowser >> list [
	^ list
]

{ #category : #accessing }
MooseTaskBrowser >> listPresenter [
	^ listPresenter
]

{ #category : #accessing }
MooseTaskBrowser >> loadButton [
	^ loadButton
]

{ #category : #menu }
MooseTaskBrowser >> mooseTaskListMenu: aMenu shifted: shifted [
	listPresenter selectedItem ifNil: [ ^ nil ].
	aMenu addAllFromPragma: 'mooseTaskListMenu' target: self.
	^ aMenu
]

{ #category : #shortcuts }
MooseTaskBrowser >> registerMooseTaskListShortcuts: aWidget [
		aWidget
		bindKeyCombination: $i meta
		toAction: [ listPresenter selectedItem ifNotNil: [ self inspectTask] ].
	aWidget
		bindKeyCombination: $d meta
		toAction: [ listPresenter selectedItem ifNotNil: [ self deleteTask  ] ].
]

{ #category : #accessing }
MooseTaskBrowser >> repositoryView [
^repositoryView
]

{ #category : #actions }
MooseTaskBrowser >> run [
	MooseJob new
		steps:
			(listPresenter listItems
				collect: [ :t | 
					MooseTaskRuntime new
						task: t;
						yourself.
					 ]);
		run.
	listPresenter resetSelection.
	^ true
]

{ #category : #accessing }
MooseTaskBrowser >> runButton [
	^ runButton
]

{ #category : #accessing }
MooseTaskBrowser >> saveButton [
	^ saveButton
]

{ #category : #actions }
MooseTaskBrowser >> setTasks: aCollection [
	list
		ifNil: [ list := aCollection ]
		ifNotNil: [ aCollection do: [ :i | list add: i ] ].
	list
		ifNotNil: [ listPresenter
				items: list;
				displayBlock: [ :task | task description ];
				setIndex: listPresenter listSize ]
]

{ #category : #accessing }
MooseTaskBrowser >> state [
	^ state
]

{ #category : #'list control' }
MooseTaskBrowser >> swapItems: aNumber [
	| selectedIndex tempItem |
	selectedIndex := listPresenter getIndex.
	tempItem := list at: selectedIndex.
	list removeAt: selectedIndex.
	list add: tempItem afterIndex: selectedIndex + aNumber.
	listPresenter items: list.
	listPresenter setIndex: selectedIndex + aNumber+1.

]

{ #category : #accessing }
MooseTaskBrowser >> taskRepo [
	^ taskRepo
]

{ #category : #api }
MooseTaskBrowser >> title [ 
	^'Moose Tasks'
]

{ #category : #accessing }
MooseTaskBrowser >> upButton [
	^ upButton
]
