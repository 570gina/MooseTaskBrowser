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
		'mooseJob',
		'mooseRuntimeList',
		'settingWindow',
		'file',
		'change',
		'isRunning',
		'repositoryWindow',
		'logView'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #check }
MooseTaskBrowser class >> allIsComposedRuntime: items [

items do:[:i| (i isKindOf: MooseTaskComposedRuntime) ifFalse:[^false]].^true
]

{ #category : #specs }
MooseTaskBrowser class >> defaultSpec [
	^ SpecPanedLayout newVertical
		position: 75 percent;
		add:
			(SpecPanedLayout newHorizontal
				add: #mooseJob;
				add: #mooseRuntimeList);
		add: (SpecBoxLayout newVertical add: #logView);
		yourself
]

{ #category : #examples }
MooseTaskBrowser class >> example1 [
	<example>
	| task taskRepo test |
	taskRepo := OrderedCollection new.
	task := MooseCustomTask new
		with: [ :v | 
			| url |
			url := v input isEmptyOrNil
				ifTrue: [ 'https://github.com/fuhrmanator/FactoryVariants' ].
			Transcript
				show: 'Task 1 running';
				cr.
			GMUtility cloneRepo: url ]
		description: '1 Clone Repository'
		length: 0.
	taskRepo add: task.
	task := MooseCustomTask new
		with: [ :v | 
			| commitMetadata |
			Transcript
				show: 'Task 2 running';
				cr.
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
	taskRepo add: task.
	task := MooseCustomTask new
		with: [ :v | 
			| selectedCommits |
			Transcript
				show: 'Task 3 running';
				cr.
			selectedCommits := GMUtility
				generateSelectedCommits: (v input at: 'commitMetadata').
			Dictionary
				newFrom:
					{('loc' -> (v input at: 'loc')).
					('selectedCommits' -> selectedCommits)} ]
		description: '3 Generate Selected Commits'
		length: 0.
	taskRepo add: task.
	task := MooseCustomTask new
		with: [ :v | 
			| pairsAndTransactions |
			Transcript
				show: 'Task 4 running';
				cr.
			pairsAndTransactions := GMUtility
				generatePairsAndTransactions: (v input at: 'selectedCommits').
			Dictionary
				newFrom:
					{('loc' -> (v input at: 'loc')).
					('pairsAndTransactions' -> pairsAndTransactions)} ]
		description: '4 Generate Pairs And Transactions'
		length: 0.
	taskRepo add: task.
	task := MooseCustomTask new
		with: [ :v | 
			| mseFileRef |
			Transcript
				show: 'Task 5 running';
				cr.
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
	taskRepo add: task.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 6 running';
				cr.
			GMUtility
				generateClientImplementationPairs: (v input at: 'mseFileRef').
			Dictionary
				newFrom:
					{('gitName' -> (v input at: 'gitName')).
					('pairsAndTransactions' -> (v input at: 'pairsAndTransactions'))} ]
		description: '6 Generate ClientImplementation Pairs'
		length: 0.
	taskRepo add: task.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 7 running';
				cr.
			GMUtility
				calculateCouplingIntersectionsFor: (v input at: 'gitName')
				withPairsFile: (v input at: 'pairsAndTransactions') first
				from: 'HEAD'
				to: '' ]
		description: '7 Calculate Coupling Intersections'
		length: 0.
	taskRepo add: task.
	test := MooseTaskBrowser on: MooseJob new.
	test repositoryWindow list items: taskRepo.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> example2 [
	<example>
	| task test job |
	job := MooseJob new.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task error running';
				cr.
			1 / 0.
			true ]
		description: 'a error task'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 1 running';
				cr.
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 1'.
			true ]
		description: 'a description 1'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 2 running';
				cr.
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 2'.
			true ]
		description: 'a description 2'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 3 running';
				cr.
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 3'.
			true ]
		description: 'a description 3'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 4 running';
				cr.
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 4'.
			true ]
		description: 'a description 4'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task error running';
				cr.
			1 / 0.
			true ]
		description: 'a error task'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 5 running';
				cr.
			(1 to: 10000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 5'.
			true ]
		description: 'a description 4'
		length: 0.
	job addTasks: {task}.
	test := MooseTaskBrowser on: job.
	test repositoryWindow list items: job tasks.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> example3 [
	<example>
	| task test job |
	job := MooseJob new.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 1 running';
				cr.
			1 / 0.
			true ]
		description: 'a description 1'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 2 running';
				cr.
			(1 to: 5000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 2'.
			true ]
		description: 'a description 2'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 3 running';
				cr.
			(1 to: 5000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 3'.
			true ]
		description: 'a description 3'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 4 running';
				cr.
			(1 to: 5000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 4'.
			true ]
		description: 'a description 4'
		length: 0.
	job addTasks: {task}.
	job combineTasks: (job tasks copyFrom: 3 to: 4).
	test := MooseTaskBrowser on: job.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> example4 [
	<example>
	| task test job |
	job := MooseJob new.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task +1 running';
				cr.
			v input asInteger + 1 ]
		description: '+1'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task +2 running';
				cr.
			v input asInteger + 2 ]
		description: '+2'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task +3 running';
				cr.
			v input asInteger + 3 ]
		description: '+3'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task +4 running';
				cr.
			v input asInteger + 4 ]
		description: '+4'
		length: 0.
	job addTasks: {task}.
	job combineTasks: (job tasks copyFrom: 1 to: 4).
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'count';
				cr.
			v input inject: 0 into: [ :x :sum | sum + x ] ]
		description: 'count'
		length: 0.
	job addTasks: {task}.
	test := MooseTaskBrowser on: job.
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

{ #category : #'list control' }
MooseTaskBrowser >> combineSelected [
	| index |
	index := (taskTableMorph selectedIndexes sort: [ :a :b | a <= b ])
		first.
	self model combineTasks: self stepsDatasource selectedItems.
	self stepsDatasource setSelectedIndexes: index.
	self model: self model
]

{ #category : #'list control' }
MooseTaskBrowser >> deleteSelected [
	self stepsDatasource selectedItems
		do: [ :i | self model removeTask: i ].
	self stepsDatasource setSelectedItems: #().
	self model: self model
]

{ #category : #initialization }
MooseTaskBrowser >> initializePresenter [
	mooseJob
		whenTaskListSelectionChanged: [ :selection | self manageArrowButtons: selection ].
	mooseJob whenUpButtonIsClicked: [ self swapItems: -1 ].
	mooseJob whenDownButtonIsClicked: [ self swapItems: 1 ].
	mooseJob whenNewJobButtonIsClicked: [ self newAnEmptyJob ].
	mooseJob whenLoadButtonIsClicked: [ self loadAJob ].
	mooseJob whenSaveButtonIsClicked: [ self saveTheJob ].
	mooseJob whenAddButtonIsClicked: [ self manageTaskAddDialog ].
	mooseJob whenSettingButtonIsClicked: [ self manageSettingDialog ].
	mooseJob whenRunButtonIsClicked: [ self run ].
	mooseRuntimeList
		runner: self model runner
		runWithUpdatingBlock: [ self model: self model ].
	mooseRuntimeList
		whenTaskRuntimeListSelectionChanged: [ :selection | self printDetail: selection ]
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWidgets [
	change := false.
	isRunning := false.
	mooseJob := self instantiate: MooseJobPresenter.
	mooseRuntimeList := self instantiate: MooseRuntimeListPresenter.
	logView := self newText disable.
	logView text: 'Error Log'.
	repositoryWindow := self instantiate: AddTasksPresenter.
	settingWindow := self instantiate: RunSettingPresenter.
	self focusOrder
		add: mooseJob;
		add: mooseRuntimeList;
		add: logView
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 60 @ 18 * (fontWidth @ rowHeight).
	aWindowPresenter title: 'Moose Task Browser'
]

{ #category : #actions }
MooseTaskBrowser >> inspectSelected [
	^ self stepsDatasource selectedItems inspect
]

{ #category : #actions }
MooseTaskBrowser >> loadAJob [
	| state |
	(self model tasks isEmpty and: [ file isNil ])
		ifTrue: [ change := false ].
	self saveChangesDialog
		ifTrue: [ state := file.
			file := MooseJobFile new.
			file load
				ifTrue: [ self model: file job.
					self window title: 'Moose Tasks -> ' , file fileName , '.txt'.
					self inform: 'Loaded'.
					mooseRuntimeList detailView text: 'Detail Display'.
					change := false ]
				ifFalse: [ file := state ] ]
]

{ #category : #actions }
MooseTaskBrowser >> manageArrowButtons: aSelection [
	"	(aSelection newSelectedIndexes isEmptyOrNil
		or: aSelection newSelectedIndexes size > 1)
		ifFalse: [ selectedItem := self model tasks
				at: aSelection newSelectedIndexes first.
			selectedItem
				ifNotNil: [ self model tasks first = selectedItem
						ifTrue: [ upButton disable ]
						ifFalse: [ upButton enable ].
					self model tasks last = selectedItem
						ifTrue: [ downButton disable ]
						ifFalse: [ downButton enable ] ] ]
		ifTrue: [ upButton disable.
			downButton disable ]"

	
]

{ #category : #actions }
MooseTaskBrowser >> manageSettingDialog [
	self model input
		ifNotNil: [ settingWindow inputText: self model input ].
	settingWindow openDialogWithSpec
		okAction: [ self model input: settingWindow inputText text asString.
			self model
				runner: settingWindow runnerList selection selectedItem model.
			settingWindow window close ]
]

{ #category : #actions }
MooseTaskBrowser >> manageTaskAddDialog [
	"| items |
	items := taskList selection selectedPaths.
	self halt."

	repositoryWindow openDialogWithSpec
		okAction: [ | steps |
			steps := repositoryWindow list selectedItems asOrderedCollection
				sort: [ :a :b | a description <= b description ].
			self model addTasks: steps.
			self model: self model.
			"		taskList selectItems: items."
			repositoryWindow list unselectAll.
			repositoryWindow window close ]
]

{ #category : #accessing }
MooseTaskBrowser >> modelChanged [
	mooseJob taskList roots: self model tasks.
	mooseJob taskList
		children: [ :aGroup | 
			aGroup class = MooseComposedTask
				ifTrue: [ aGroup tasks ]
				ifFalse: [ {} ] ];
		beResizable.
	change := true.
	self updateRuntimeList.
	self updateLogText.
	self model tasks
		ifEmpty: [ mooseJob upButton disable.
			mooseJob downButton disable.
			mooseJob runButton disable.
			mooseJob saveButton disable.
			mooseJob loadButton enable.
			mooseJob newJobButton disable ]
		ifNotEmpty: [ mooseJob saveButton enable.
			mooseJob newJobButton enable.
			isRunning
				ifFalse: [ mooseJob runButton enable ] ].
	file
		ifNotNil: [ mooseJob saveButton enable.
			mooseJob newJobButton enable ]
]

{ #category : #accessing }
MooseTaskBrowser >> mooseJob [
^mooseJob
]

{ #category : #actions }
MooseTaskBrowser >> newAnEmptyJob [
	self saveChangesDialog
		ifTrue: [ file := nil.
			self model: MooseJob new.
			self window title: 'Moose Task Browser' .mooseRuntimeList detailView text: 'Detail Display'.]
]

{ #category : #actions }
MooseTaskBrowser >> printDetail: item [
	item selectedItem ifNil: [ ^ self ].
	 mooseRuntimeList detailView text: item selectedItem printString
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
MooseTaskBrowser >> repositoryWindow [
^repositoryWindow
]

{ #category : #actions }
MooseTaskBrowser >> run [
	mooseRuntimeList detailView text: 'Detail Display'.
	mooseJob runButton disable.
	isRunning := true.
	self model runWithUpdatingBlock: [ self model: self model ].
	mooseJob runButton enable.
	isRunning := false
]

{ #category : #actions }
MooseTaskBrowser >> saveChangesDialog [
	| select |
	change
		ifTrue: [ select := self uiManager
				confirm: 'Save changes?'
				label: 'Question'
				trueChoice: 'Yes'
				falseChoice: 'No'
				cancelChoice: 'Cancel'
				default: true.
			select
				ifNil: [ ^ false ];
				ifTrue: [ self saveTheJob
							ifFalse: [ ^ false ] ] ].
	^ true
]

{ #category : #actions }
MooseTaskBrowser >> saveTheJob [
	| state |
	state := file.
	file ifNil: [ file := MooseJobFile new ].
	file job: self model.
	file saveAs
		ifTrue: [ self uiManager inform: 'Saved'.
			self window title: 'Moose Tasks -> ' , file fileName , '.txt'.
			change := false.
			^ true ]
		ifFalse: [ file := state.
			^ false ]
]

{ #category : #'list control' }
MooseTaskBrowser >> separateSelected [
	| index |
	index := (taskTableMorph selectedIndexes sort: [ :a :b | a <= b ])
		first.
	self model separateTasks: self stepsDatasource selectedItems.
	self stepsDatasource setSelectedIndexes: index.
	self model: self model
]

{ #category : #'list control' }
MooseTaskBrowser >> swapItems: aNumber [
	| items |
	items := self stepsDatasource selectedItems.
	items do: [ :item | self model move: aNumber theTask: item ].
	self stepsDatasource setSelectedItems: items.
	self model: self model
]

{ #category : #private }
MooseTaskBrowser >> uiManager [ 

	^ UIManager default
			
]

{ #category : #actions }
MooseTaskBrowser >> updateLogText [
	| log |
	self model runtimeJobs
		ifNil: [ log := 'Error Log' ]
		ifNotNil: [ log := ''.
			self model runtimeJobs
				do: [ :job | 
					job errorState
						ifNotNil: [ log := log , job description asString , String lf
								, job errorState asString ] ] ].
	logView text: log
]

{ #category : #actions }
MooseTaskBrowser >> updateRuntimeList [
	mooseRuntimeList taskRuntimeList
		roots: (self model runtimeJobs ifNil: [ {} ]).
	mooseRuntimeList taskRuntimeList
		children: [ :aGroup | 
			aGroup class = MooseTaskRuntime
				ifTrue: [ {} ]
				ifFalse: [ aGroup tasks ] ];
		beResizable
]
