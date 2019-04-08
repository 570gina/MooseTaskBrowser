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
		'saveButton',
		'loadButton',
		'addButton',
		'upButton',
		'downButton',
		'runButton',
		'taskRepo',
		'repositoryView',
		'runner',
		'checkBox',
		'taskTable',
		'taskTableMorph',
		'stepsDatasource',
		'file',
		'newJobButton',
		'change'
	],
	#category : #'Tools-MooseTaskBrowser-core-ui'
}

{ #category : #check }
MooseTaskBrowser class >> allIsComposedRuntime: items [

items do:[:i| (i isKindOf: MooseTaskComposedRuntime) ifFalse:[^false]].^true
]

{ #category : #specs }
MooseTaskBrowser class >> defaultSpec [
	^ SpecColumnLayout composed
		newRow: [ :row | 
			row
				add: #checkBox width: self defaultFont height;
				newRow: [ :inRow | 
					inRow
						add: #newJobButton;
						add: #loadButton;
						add: #saveButton;
						add: #addButton ] ]
			height: self toolbarHeight;
		newRow: [ :row | 
			row
				add: #taskTable;
				newColumn: [ :col | 
					col
						add: #upButton;
						add: #downButton ]
					width: self defaultFont height + 6 ];
		newRow: [ :row | row add: #runButton ] height: self toolbarHeight;
		yourself
]

{ #category : #examples }
MooseTaskBrowser class >> example1 [
	<example>
	| task taskRepo test |
	taskRepo := MooseTaskRepository new.
	task := MooseCustomTask new
		with: [ :v | 
			| loc |
			loc := UIManager default
				request: 'Please insert the url to clone, with argument: '
				initialAnswer: 'https://github.com/fuhrmanator/FactoryVariants' ]
		description: '0 prompt url'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | GMUtility cloneRepo: v input ]
		description: '1 Clone Repository'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| commitMetadata |
			commitMetadata := GMUtility
				filterCommitsOnRepoLeftBranchOnly: v input
				from: 'HEAD'
				to: ''.
			Dictionary
				newFrom:
					{('loc' -> v input).
					('commitMetadata' -> commitMetadata)} ]
		description: '2 Filter Commits On Repository Left Branch'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| selectedCommits |
			selectedCommits := GMUtility
				generateSelectedCommits: (v input at: 'commitMetadata').
			Dictionary
				newFrom:
					{('loc' -> (v input at: 'loc')).
					('selectedCommits' -> selectedCommits)} ]
		description: '3 Generate Selected Commits'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| pairsAndTransactions |
			pairsAndTransactions := GMUtility
				generatePairsAndTransactions: (v input at: 'selectedCommits').
			Dictionary
				newFrom:
					{('loc' -> (v input at: 'loc')).
					('pairsAndTransactions' -> pairsAndTransactions)} ]
		description: '4 Generate Pairs And Transactions'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			| mseFileRef |
			Transcript show: 'here'; cr.
			mseFileRef := GMUtility
				generateMSEFileFor: 'HEAD'
				reponame: (v input at: 'loc') basename.
			Dictionary
				newFrom:
					{('gitName' -> (v input at: 'loc') basename).
					('pairsAndTransactions' -> (v input at: 'pairsAndTransactions')).
					('mseFileRef' -> mseFileRef)} ]
		description: '5 Generate MSE File For StartOID'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			GMUtility
				generateClientImplementationPairs: (v input at: 'mseFileRef').
			Dictionary
				newFrom:
					{('gitName' -> (v input at: 'gitName')).
					('pairsAndTransactions' -> (v input at: 'pairsAndTransactions'))} ]
		description: '6 Generate ClientImplementation Pairs'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			GMUtility
				calculateCouplingIntersectionsFor: (v input at: 'gitName')
				withPairsFile: (v input at: 'pairsAndTransactions') first
				from: 'HEAD'
				to: '' ]
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
	| task taskRepo test |
	taskRepo := MooseTaskRepository new.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 1'.
			true ]
		description: 'a description 1'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 50000000)
				do: [ :i | 1/0.true ]
				displayingProgress: 'running task: 2'.
			true ]
		description: 'a description 2'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 3'.
			true ]
		description: 'a description 3'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 50000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 4'.
			true ]
		description: 'a description 4'
		length: 0.
	taskRepo addTask: task.
	test := MooseTaskBrowser on: MooseJob new.
	test repositoryView setList: taskRepo tasks.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> example3 [
	<example>
	| task taskRepo test |
	taskRepo := MooseTaskRepository new.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 1'.
			2 ]
		description: 'a description 1'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 2'.
			v input + 2 ]
		description: 'a description 2'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | 
			(1 to: 20000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 3'.
			v input + 2 ]
		description: 'a description 3'
		length: 0.
	taskRepo addTask: task.
	test := MooseTaskBrowser on: MooseJob new.
	test repositoryView setList: taskRepo tasks.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> example4 [
	<example>
	| task taskRepo test |
	taskRepo := MooseTaskRepository new.
	task := MooseCustomTask new
		with: [ :v | v input asInteger + 3 ]
		description: '+3'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | v input asInteger + 4 ]
		description: '+4'
		length: 0.
	taskRepo addTask: task.
	task := MooseCustomTask new
		with: [ :v | v input first asInteger+ v input second asInteger]
		description: '++'
		length: 0.
	taskRepo addTask: task.
	test := MooseTaskBrowser on: MooseJob new.
	test repositoryView setList: taskRepo tasks.
	test openWithSpec
]

{ #category : #menu }
MooseTaskBrowser class >> menu: aBuilder [
	<contextMenu>
	<mooseTaskBrowserMenu>
	| target items |
	target := aBuilder model.
	items := target stepsDatasource selectedItems.
	items size > 1
		ifTrue: [ (aBuilder item: #Combine)
				icon: (self iconNamed: #collection);
				selector: #combineSelected ].
	(self allIsComposedRuntime: items)
		ifTrue: [ (aBuilder item: #Separate)
				icon: (self iconNamed: #windowMinimizeInactive);
				selector: #separateSelected ].
	(aBuilder item: #Inspect)
		icon: (self iconNamed: #smallInspectIt);
		keyText: 'i';
		selector: #inspectSelected.
	(aBuilder item: #Delete)
		icon: (self iconNamed: #delete);
		keyText: 'd';
		selector: #deleteSelected
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
MooseTaskBrowser >> change [
^change
]

{ #category : #accessing }
MooseTaskBrowser >> checkBox [
^checkBox
]

{ #category : #'list control' }
MooseTaskBrowser >> checkedAllBox [
	self model forceRunAllSteps.
	self model: self model

	
]

{ #category : #'list control' }
MooseTaskBrowser >> combineSelected [
	| index |
	index := (taskTableMorph selectedRowIndexes sort: [ :a :b | a <= b ])
		first.
	self model combineSteps: self stepsDatasource selectedItems.
	self stepsDatasource setSelectedIndexes: index.
	self model: self model
]

{ #category : #'list control' }
MooseTaskBrowser >> deleteSelected [
	self stepsDatasource selectedItems
		do: [ :i | self model removeStep: i ].
	self stepsDatasource setSelectedItems: #().
	self model: self model
]

{ #category : #accessing }
MooseTaskBrowser >> downButton [
	^ downButton
]

{ #category : #shortcuts }
MooseTaskBrowser >> ensureKeyBindingsFor: aWidget [
	super ensureKeyBindingsFor: aWidget.
	self registerMooseTaskListShortcuts: taskTable
]

{ #category : #api }
MooseTaskBrowser >> extent [
	^ 650 @ 400
]

{ #category : #accessing }
MooseTaskBrowser >> file [
	^ file
]

{ #category : #initialization }
MooseTaskBrowser >> initializePresenter [
	taskTableMorph dataSource: self stepsDatasource.
	taskTableMorph
		onAnnouncement: FTSelectionChanged
		do: [ :item | self manageArrowButtons: item ].
	checkBox
		whenActivatedDo: [ self checkedAllBox ];
		whenDeactivatedDo: [ self uncheckedAllBox ].
	upButton action: [ self swapItems: -1 ].
	downButton action: [ self swapItems: 1 ].
	runButton action: [ self run ].
	addButton action: [ self manageTaskAddDialog ].
	saveButton action: [ self saveTheJob ].
	loadButton action: [ self loadAJob ].
	newJobButton action: [ self newAnEmptyJob ].
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWidgets [
	self title: 'Moose Tasks'.
	change := false.
	taskTableMorph := self newTable.
	taskTableMorph.
	taskTable := taskTableMorph asSpecAdapter.
	checkBox := self newCheckBox.
	newJobButton := self newButton
		label: 'New Job';
		icon: (self iconNamed: #page).
	loadButton := self newButton
		label: 'Load Job';
		icon: (self iconNamed: #smallOpen).
	saveButton := self newButton
		label: 'Save Job';
		icon: (self iconNamed: #glamorousSave).
	addButton := self newButton
		label: 'Add Tasks';
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
		add: taskTable;
		add: runButton;
		add: checkBox
]

{ #category : #accessing }
MooseTaskBrowser >> inspectSelected [
	^ self stepsDatasource selectedItems inspect
]

{ #category : #actions }
MooseTaskBrowser >> loadAJob [
	| state |
	(self model steps isEmpty and: file isNil)
		ifTrue: [ change := false ].
	self saveChangesDialog
		ifTrue: [ state := file.
			file := MooseJobFile new.
			file load
				ifTrue: [ self model: file job.
					self title: 'Moose Tasks -> ' , file fileName , '.txt'.
					self inform: 'Loaded'.
					self stepsDatasource setSelectedItems: #().
					change := false ]
				ifFalse: [ file := state ] ]
]

{ #category : #accessing }
MooseTaskBrowser >> loadButton [
	^ loadButton
]

{ #category : #actions }
MooseTaskBrowser >> manageArrowButtons: aSelection [
	| selectedItem |
	(aSelection newSelectedRowIndexes isEmptyOrNil
		or: aSelection newSelectedRowIndexes size > 1)
		ifFalse: [ selectedItem := self model steps
				at: aSelection newSelectedRowIndexes first.
			selectedItem
				ifNotNil: [ self model steps first = selectedItem
						ifTrue: [ upButton disable ]
						ifFalse: [ upButton enable ].
					self model steps last = selectedItem
						ifTrue: [ downButton disable ]
						ifFalse: [ downButton enable ] ] ]
		ifTrue: [ upButton disable.
			downButton disable ]
]

{ #category : #actions }
MooseTaskBrowser >> manageTaskAddDialog [
	| items |
	items := self stepsDatasource selectedItems.
	repositoryView openDialogWithSpec
		okAction: [ | steps |
			steps := repositoryView listPresenter selectedItems
				asOrderedCollection
				sort: [ :a :b | a description <= b description ].
			steps := steps collect: #asTaskRuntime.
			self model addSteps: steps.
			self model: self model.
			self stepsDatasource setSelectedItems: items.
			repositoryView listPresenter resetSelection ]
]

{ #category : #accessing }
MooseTaskBrowser >> modelChanged [
	self stepsDatasource elements: self model steps.
	taskTableMorph refresh.
	checkBox state: false.
	change := true.
	self model steps
		ifEmpty: [ upButton disable.
			downButton disable.
			checkBox disable.
			runButton disable.
			saveButton disable.
			loadButton enable.
			newJobButton disable ]
		ifNotEmpty: [ checkBox enable.
			runButton enable.
			saveButton enable.
			newJobButton enable ].
	file
		ifNotNil: [ saveButton enable.
			newJobButton enable ]
]

{ #category : #initialization }
MooseTaskBrowser >> newAnEmptyJob [
	self saveChangesDialog
ifTrue: [  
	file := nil.
	self stepsDatasource setSelectedItems: #().
	self model: MooseJob new.
	self title: 'Moose Tasks'.
]
]

{ #category : #initialization }
MooseTaskBrowser >> newJobButton [
^newJobButton
]

{ #category : #initialization }
MooseTaskBrowser >> newTable [
	^ FTTableMorph new
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		beMultipleSelection;
		rowHeight: 70
]

{ #category : #shortcuts }
MooseTaskBrowser >> registerMooseTaskListShortcuts: aWidget [
	aWidget
		bindKeyCombination: $i meta
		toAction: [ self stepsDatasource selectedItems ifNotNil: [ self inspectSelected ] ].
	aWidget
		bindKeyCombination: $d meta
		toAction: [ self stepsDatasource selectedItems ifNotNil: [ self deleteSelected ] ]
]

{ #category : #accessing }
MooseTaskBrowser >> repositoryView [
^repositoryView
]

{ #category : #actions }
MooseTaskBrowser >> run [
	runButton disable.
	self model
		input:
			(UIManager default
				request: 'Provide the input for first task: '
				initialAnswer: self model input asString).
	(self model runWithUpdatingBlock: [ self model: self model ])
		addSuccessCallback: [ :result | 
			self inform: 'Tasks finished.'.
			self model: self model.
			runButton enable ].
	checkBox state: false
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
MooseTaskBrowser >> saveChangesDialog [
	| select |
	change
		ifTrue: [ select := UIManager default
				confirm: 'Save changes?'
				label: 'Question'
				trueChoice: 'Yes'
				falseChoice: 'No'
				cancelChoice: 'Cancel'
				default: true.
			select
				ifNil: [ ^ false ];
				ifTrue: [ self saveTheJob
							ifFalse: [ ^ false ] ] ]
					.^true
]

{ #category : #actions }
MooseTaskBrowser >> saveTheJob [
	| state |
	state := file.
	file ifNil: [ file := MooseJobFile new ].
	file job: self model.
	file saveAs
		ifTrue: [ 
			self inform: 'Saved'.
			self title: 'Moose Tasks -> ' , file fileName , '.txt'.change := false.
			^ true ]
		ifFalse: [ file := state.
			^ false ]
]

{ #category : #'list control' }
MooseTaskBrowser >> separateSelected [
	| index |
	index := (taskTableMorph selectedRowIndexes sort: [ :a :b | a <= b ])
		first.
	self model separateSteps: self stepsDatasource selectedItems.
	self stepsDatasource setSelectedIndexes: index.
	self model: self model
	
]

{ #category : #menu }
MooseTaskBrowser >> setMenu: aMenu [
	self stepsDatasource selectedItems isEmptyOrNil
		ifTrue: [ ^ nil ].
	aMenu
		addAllFromPragma: 'mooseTaskBrowserMenu'
		target: self.
	^ aMenu
]

{ #category : #accessing }
MooseTaskBrowser >> stepsDatasource [
	^ stepsDatasource
		ifNil: [ stepsDatasource := MooseDataSource new
				elements: self model steps;
				menu: [ :i | self setMenu: MenuMorph new ];
				format:
						[ :c | (MooseTaskRuntimeItem owner: self on: c) buildWithSpec asMorph ] ]
]

{ #category : #'list control' }
MooseTaskBrowser >> swapItems: aNumber [
	| items |
	items := self stepsDatasource selectedItems.
	items do: [ :item | self model move: aNumber theStep: item ].
	self stepsDatasource setSelectedItems: items.
	self model: self model
]

{ #category : #accessing }
MooseTaskBrowser >> taskRepo [
	^ taskRepo
]

{ #category : #accessing }
MooseTaskBrowser >> taskTable [
	^ taskTable
]

{ #category : #'list control' }
MooseTaskBrowser >> uncheckedAllBox [
	self model doNotForceAnyStep.
	self model: self model
]

{ #category : #accessing }
MooseTaskBrowser >> upButton [
	^ upButton
]
