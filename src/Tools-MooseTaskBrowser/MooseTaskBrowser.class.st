"
Todo -
	Allow to the job to receive arguments. [ to test ]
	
	Implement a task that responds to a composite (meaning, tasks that can be runned at the same time. cooking the sauce while working the dough).
	Test test test

	Nowadays, the result of the execution of a task is beign stored in the context variable (dictionary) on the method run of the class mooseJob. 
	Change this behavior to store the result of the task into the related taskruntime object.  [ Done - To test. (test what happen if the new input is different. If the output is nil, if the output is not nil, etc ) ]
	Modify the variable context of task runtime to be named ""input"". Context is to vague. [ done ]
	After, ensure to cache the ""last used input"", 
	Now we can do some improvements by executing the actual task, only when the given input differs with the last input. [ Done. Still needs testing!  ]
	This last behaviours needs much testing. 
	
	modify the MooseTaskRuntime to be as a composite of many childs.
	ensure to implement run: for multiple childs. 
	test adn test and test again
	and come to ask me if you need something anddd:
	test and test and test and think in how to implement a MooseJobRunner that executes each taskruntime in a specific way. 
	
	
	Modify the UI for: 
		1 allowing the job to receive arguments. [ not yet interesting  ]
		2 display the job's output. (or allow to inspect it)
		3 reuse the job many times instead of using allways a new one (this will allow us to *really* use the cached result mechanism ) [ done, needs testing ]
		4 allow from the ui to mark as "" to re-execute "" one or many tasks 
		5 allow the user to specify if many tasks can run together (or they share input)
	
			

		
"
Class {
	#name : #MooseTaskBrowser,
	#superclass : #ComposablePresenterWithModel,
	#instVars : [
		'listPresenter',
		'saveButton',
		'loadButton',
		'addButton',
		'upButton',
		'downButton',
		'runButton',
		'taskRepo',
		'repositoryView',
		'runner',
		'checkBox'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #specs }
MooseTaskBrowser class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #checkBox width: self defaultFont height;
				newRow: [ :inRow | 
					inRow
						add: #loadButton;
						add: #saveButton;
						add: #addButton ] ]
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

{ #category : #examples }
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
				filterCommitsOnRepoLeftBranchOnly: v input
				from: startOIDString
				to: endOIDString.
			Array with: v input with: output ]
		description: '2 Filter Commits On Repository Left Branch'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| output |
			output := GMUtility generateSelectedCommits: v input second.
			Array with: v input first with: output ]
		description: '3 Generate Selected Commits'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| output |
			output := GMUtility generatePairsAndTransactions: v input second.
			Array with: v input first with: output ]
		description: '4 Generate Pairs And Transactions'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| output |
			output := GMUtility
				generateMSEFileFor: startOIDString
				reponame: v input first basename.
			Array with: v input second with: output ]
		description: '5 Generate MSE File For StartOID'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			GMUtility generateClientImplementationPairs: v input second.
			v input first ]
		description: '6 Generate ClientImplementation Pairs'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			GMUtility
				calculateCouplingIntersectionsFor: gitName
				withPairsFile: v input first
				from: startOIDString
				to: endOIDString ]
		description: '7 Calculate Coupling Intersections'
		length: 0.
	taskRepo addTask: task.
	test := MooseTaskBrowser on: MooseJob new.
	test repositoryView setList: taskRepo tasks.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> example2 [
	<example>
	| requestUrl clone taskRepo test gitName startOIDString endOIDString |
	gitName := 'FactoryVariants'.
	startOIDString := 'HEAD'.
	endOIDString := ''.
	taskRepo := MooseTaskRepository new.
	requestUrl := MooseCustomTask new
		with: [ :v | 
			| loc |
			loc := UIManager default
				request: 'Please insert the url to clone, with argument: '
				initialAnswer: 'https://github.com/fuhrmanator/FactoryVariants' ]
		description: '0 prompt url'
		length: 0.
	taskRepo addTask: requestUrl.
	clone := MooseCustomTask new
		with: [ :v | GMUtility cloneRepo: v input ]
		description: '1 Clone Repository'
		length: 0.
	taskRepo addTask: clone.
	test := MooseTaskBrowser on: MooseJob new.
	test repositoryView setList: taskRepo tasks.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> example3 [
	<example>
	| task1 task2 taskRepo test |
	taskRepo := MooseTaskRepository new.
	task1 := MooseCustomTask new
		with: [ :v | 
			(1 to: 6000000)
				do: [ :i | true ]
				displayingProgress: 'running task: '.
			true ]
		description: 'a description 1'
		length: 0.
	taskRepo addTask: task1.
	task2 := MooseCustomTask new
		with: [ :v | 
			(1 to: 6000000)
				do: [ :i | true ]
				displayingProgress: 'running task: '.
			true ]
		description: 'a description 2'
		length: 0.
	taskRepo addTask: task2.
	test := MooseTaskBrowser on: MooseJob new.
	test repositoryView setList: taskRepo tasks.
	test openWithSpec
]

{ #category : #menu }
MooseTaskBrowser class >> menuMooseTask: aBuilder [
	<contextMenu>
	<mooseTaskListMenu>
	| target listPresenter |
	target := aBuilder model.
	listPresenter := target listPresenter.
	listPresenter selectedItems size > 1
		ifTrue: [ (aBuilder item: #Combine)
				icon: (self iconNamed: #collection);
				selector: #combineTasks ]
		ifFalse: [ (aBuilder item: #Inspect)
				icon: (self iconNamed: #smallInspectIt);
				keyText: 'i';
				selector: #inspectTask ].
	(aBuilder item: #Delete)
		icon: (self iconNamed: #delete);
		keyText: 'd';
		selector: #deleteTasks.
]

{ #category : #api }
MooseTaskBrowser >> aboutText [
	^ 'Moose Task Browser'
]

{ #category : #accessing }
MooseTaskBrowser >> addButton [
	^ addButton
]

{ #category : #accessing }
MooseTaskBrowser >> checkBox [
^checkBox
]

{ #category : #actions }
MooseTaskBrowser >> checkedAllBox [
	listPresenter selectAll
]

{ #category : #'list control' }
MooseTaskBrowser >> deleteTasks [
	listPresenter selectedItems
		do: [ :i | self model removeStep: i content ].
	self model: self model.

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
	^ 650 @ 400
]

{ #category : #initialization }
MooseTaskBrowser >> initializePresenter [
	listPresenter
		whenSelectedItemChanged: [ :item | self manageArrowButtons: item ].
	checkBox
		whenActivatedDo: [ self checkedAllBox ];
		whenDeactivatedDo: [ self uncheckedAllBox ].
	upButton action: [ self swapItems: -1 ].
	downButton action: [ self swapItems: 1 ].
	runButton action: [ self run ].
	addButton action: [ self manageTaskAddDialog ]
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWidgets [
	listPresenter := self newTree beCheckList.
	listPresenter autoMultiSelection: true.
	listPresenter
		menu: [ :menu :shifted | self mooseTaskListMenu: menu shifted: shifted ].
	checkBox := self newCheckBox.
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
	self focusOrder
		add: loadButton;
		add: saveButton;
		add: addButton;
		add: upButton;
		add: downButton;
		add: listPresenter;
		add: runButton;
		add: checkBox
]

{ #category : #'list control' }
MooseTaskBrowser >> inspectTask [
	listPresenter selectedItem content task inspect
]

{ #category : #accessing }
MooseTaskBrowser >> listPresenter [
	^ listPresenter
]

{ #category : #accessing }
MooseTaskBrowser >> loadButton [
	^ loadButton
]

{ #category : #actions }
MooseTaskBrowser >> manageArrowButtons: item [
	upButton disable.
	downButton disable.
	checkBox disable.
	self model steps
		ifNotEmpty: [ checkBox enable.listPresenter selectedItems size = 1
				ifTrue: [ upButton enable.
					downButton enable.
					self model steps first = item
						ifTrue: [ upButton disable ].
					self model steps last = item
						ifTrue: [ downButton disable ] ] ]
]

{ #category : #actions }
MooseTaskBrowser >> manageTaskAddDialog [
	repositoryView openDialogWithSpec
		okAction: [ | steps |
			steps := repositoryView listPresenter selectedItems
				asOrderedCollection
				sort: [ :a :b | a description <= b description ].
			steps := steps collect: #asTaskRuntime.
			self model addSteps: steps.
			self model: self model.
			checkBox enabled: false.
			listPresenter resetSelection.
			repositoryView listPresenter resetSelection ]
]

{ #category : #accessing }
MooseTaskBrowser >> modelChanged [
	listPresenter roots: self model steps.
	self model steps
		ifEmpty: [ runButton disable ]
		ifNotEmpty: [ runButton enable ]
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
		toAction: [ listPresenter selectedItem ifNotNil: [ self inspectTask ] ].
	aWidget
		bindKeyCombination: $d meta
		toAction: [ listPresenter selectedItem ifNotNil: [ self deleteTasks ] ]
]

{ #category : #accessing }
MooseTaskBrowser >> repositoryView [
^repositoryView
]

{ #category : #actions }
MooseTaskBrowser >> run [
	| temp |
	temp := listPresenter selectedItems.
	[ runButton disable.
	self model run.
	self inform: 'Task finished' ]
		ensure: [ runButton enable ].
	self model: self model.
	listPresenter selectAll.
]

{ #category : #accessing }
MooseTaskBrowser >> runButton [
	^ runButton
]

{ #category : #accessing }
MooseTaskBrowser >> saveButton [
	^ saveButton
]

{ #category : #'list control' }
MooseTaskBrowser >> swapItems: aNumber [
"
	| thisIndex thatIndex |
	thisIndex := listPresenter selectedIndex.
	thatIndex := thisIndex + aNumber.
	self model steps swap: thisIndex with: thatIndex.
	self model: self model.
	listPresenter setIndex: thatIndex"
]

{ #category : #accessing }
MooseTaskBrowser >> taskRepo [
	^ taskRepo
]

{ #category : #api }
MooseTaskBrowser >> title [ 
	^'Moose Tasks'
]

{ #category : #actions }
MooseTaskBrowser >> uncheckedAllBox [
	listPresenter deselectAll
]

{ #category : #accessing }
MooseTaskBrowser >> upButton [
	^ upButton
]
