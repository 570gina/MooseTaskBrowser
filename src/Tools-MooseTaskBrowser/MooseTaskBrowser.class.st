Class {
	#name : #MooseTaskBrowser,
	#superclass : #ComposablePresenterWithModel,
	#instVars : [
		'file',
		'change',
		'logView',
		'mooseJobPresenter',
		'mooseJobRuntimePresenter',
		'taskAdditionPresenter',
		'runSettingPresenter'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #check }
MooseTaskBrowser class >> allIsComposedRuntime: items [

items do:[:i| (i isKindOf: MooseTaskComposedRuntime) ifFalse:[^false]].^true
]

{ #category : #specs }
MooseTaskBrowser class >> defaultSpec [
	^ SpecPanedLayout newHorizontal
		position: 67 percent;
		add:
			(SpecPanedLayout newHorizontal
				add: #mooseJobPresenter;
				add: #mooseJobRuntimePresenter);

			add: #logView;
		yourself
]

{ #category : #examples }
MooseTaskBrowser class >> exampleAdder [
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
	task := MooseCustomTask new
		with: [ 5 ]
		description: 'Integer 5'
		length: 0.
	test taskAdditionPresenter list items: {task}.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> exampleError [
	<example>
	| task test job |
	job := MooseJob new.
	task := MooseCustomTask new
		with: [ Transcript
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
		with: [ Transcript
				show: 'Task error running';
				cr.
			MooseTaskError signal: ' an error '.
			true ]
		description: 'a MooseTaskError task'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ Transcript
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
		with: [ Transcript
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
		with: [ Transcript
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
		with: [ Transcript
				show: 'Task error running';
				cr.
			1 / 0.
			true ]
		description: 'an error task'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ Transcript
				show: 'Task 4 running';
				cr.
			(1 to: 50000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 4'.
			true ]
		description: 'a description 4'
		length: 0.
	job addTasks: {task}.
	test := MooseTaskBrowser on: job.
	test taskAdditionPresenter list items: job tasks.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> exampleGMUtility [
	<example>
	| task taskRepo test |
	taskRepo := OrderedCollection new.
	task := MooseCustomTask new
		with: [ :v | 
			| url |
			url := v input  isEmptyOrNil
				ifTrue: [ 'https://github.com/fuhrmanator/FactoryVariants' ]
				ifFalse: [ v input ].
			GMUtility cloneRepo: url ]
		description: '1 Clone Repository'
		length: 0.
	taskRepo add: task.
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
	test taskAdditionPresenter list items: taskRepo.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> exampleGroupAndError [
	<example>
	| task test job |
	job := MooseJob new.
	task := MooseCustomTask new
		with: [ 1 / 0 ]
		description: 'an error task'
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
		with: [ :v | 1 / 0 ]
		description: 'a description 3'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 4 running';
				cr.
			(1 to: 100000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 4'.
			true ]
		description: 'a description 4'
		length: 0.
	job addTasks: {task}.
	job combineTasks: (job tasks copyFrom: 3 to: 4).
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 5 running';
				cr.
			(1 to: 100000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 5'.
			true ]
		description: 'a description 5'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task 6 running';
				cr.
			(1 to: 100000000)
				do: [ :i | true ]
				displayingProgress: 'running task: 6'.
			true ]
		description: 'a description 6'
		length: 0.
	job addTasks: {task}.
	test := MooseTaskBrowser on: job.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> exampleNewClass [
	<example>
	| task test job |
	job := MooseJob new.
	task := MooseCustomTask new
		with: [ :v | HelloTest new ]
		description: 'HelloTest new'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ Object subclass: #HelloTest ]
		description: 'define class'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | v input asString ]
		description: 'print input'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | HelloTest new ]
		description: 'HelloTest new'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | v input asString ]
		description: 'print input'
		length: 0.
	job addTasks: {task}.
	test := MooseTaskBrowser on: job.
	test openWithSpec
]

{ #category : #examples }
MooseTaskBrowser class >> exampleTest [
	<example>
	| task test job |
	job := MooseJob new.
	task := MooseCustomTask new
		with: [ :v | 
			Transcript
				show: 'Task running';
				cr.
			(1 to: 50000000) do: [ :i | true ] displayingProgress: 'running'.
			true ]
		description: 'a description'
		length: 0.
	job addTasks: {task}.
	task := MooseCustomTask new
		with: [ :v | 1 / 0 ]
		description: '+4'
		length: 0.
	job addTasks: {task}.
	job combineTasks: (job tasks copyFrom: 1 to: 2).
	test := MooseTaskBrowser on: job.
	test openWithSpec
]

{ #category : #api }
MooseTaskBrowser >> aboutText [
	^ 'Moose Task Browser'
]

{ #category : #actions }
MooseTaskBrowser >> addJobMenuItems [

	mooseJobPresenter menu
		addItem: [ :anItem | 
			anItem
				name: 'Inspect';
				visibleIf: [ mooseJobPresenter taskList selection selectedPaths size = 1 ];
				action: [ mooseJobPresenter inspectSelectedItem ] ];
		addItem: [ :anItem | 
			anItem
				name: 'Delete';
				visibleIf: [ mooseJobPresenter taskList selection selectedPaths size = 1
						and: [ mooseJobPresenter taskList selection selectedPaths
		allSatisfy: [ :path | path size = 1 ] ] ];
				action: [ self deleteSelected ] ];
		addItem: [ :anItem | 
			anItem
				name: 'Combine';
				visibleIf: [ mooseJobPresenter taskList selection selectedPaths size > 1
						and: [ mooseJobPresenter taskList selection selectedPaths
		allSatisfy: [ :path | path size = 1 ] ] ];
				action: [ self combineSelected ] ];
		addItem: [ :anItem | 
			anItem
				name: 'Separate';
				visibleIf: [ (mooseJobPresenter taskList selection selectedItems
						anySatisfy: [ :item | item class = MooseComposedTask ])
						and: [ mooseJobPresenter taskList selection selectedPaths
		allSatisfy: [ :path | path size = 1 ] ] ];
				action: [ self separateSelected ] ]
]

{ #category : #'list control' }
MooseTaskBrowser >> combineSelected [
	| index selection |
	selection := mooseJobPresenter taskList selection.
	index := (selection selectedPaths
		sort: [ :a :b | a first <= b first ]) first.
	self model combineTasks: selection selectedItems.
	self model: self model.
		selection selectPaths: {index}.
]

{ #category : #'list control' }
MooseTaskBrowser >> deleteSelected [
	self model removeTask:self mooseJobPresenter taskList selection selectedItems first.
	self mooseJobPresenter taskList selectPaths: #().
	self model: self model
]

{ #category : #initialization }
MooseTaskBrowser >> initializePresenter [
	mooseJobPresenter
		whenTaskListSelectionChanged: [ :selection | self manageArrowButtons: selection ].
	mooseJobPresenter whenUpButtonIsClicked: [ self swapItems: -1 ].
	mooseJobPresenter whenDownButtonIsClicked: [ self swapItems: 1 ].
	mooseJobPresenter whenNewJobButtonIsClicked: [ self newAnEmptyJob ].
	mooseJobPresenter whenLoadButtonIsClicked: [ self loadAJob ].
	mooseJobPresenter whenSaveButtonIsClicked: [ self saveTheJob ].
	mooseJobPresenter
		whenAddButtonIsClicked: [ self manageTaskAddDialog ].
	mooseJobPresenter
		whenSettingButtonIsClicked: [ self manageSettingDialog ].
	mooseJobPresenter whenRunButtonIsClicked: [ self run ].
	mooseJobRuntimePresenter
		runner: self model runner
		withUpdatingBlock: [ self model: self model ].
	mooseJobRuntimePresenter
		whenTaskRuntimeListSelectionChanged: [ :selection | self printDetail: selection ]
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWidgets [
	change := false.
	mooseJobPresenter := self instantiate: MooseJobPresenter.
		self addJobMenuItems.
	mooseJobRuntimePresenter := self
		instantiate: MooseJobRuntimePresenter.
	logView := self newText disable.
	taskAdditionPresenter := self instantiate: TaskAdditionPresenter.
	runSettingPresenter := self instantiate: RunSettingPresenter.
	self focusOrder
		add: mooseJobPresenter;
		add: mooseJobRuntimePresenter;
		add: logView
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWindow: aWindowPresenter [
	| fontWidth rowHeight |
	fontWidth := StandardFonts defaultFont widthOfString: 'M'.
	rowHeight := self class inputTextHeight.
	aWindowPresenter initialExtent: 75 @ 15 * (fontWidth @ rowHeight).
	aWindowPresenter title: 'Moose Task Browser'
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
					mooseJobRuntimePresenter detailView text: 'Detail Display'.
					change := false ]
				ifFalse: [ file := state ] ]
]

{ #category : #accessing }
MooseTaskBrowser >> logView [
^logView
]

{ #category : #actions }
MooseTaskBrowser >> manageArrowButtons: aSelection [
	(aSelection size = 1 and: [ aSelection first size = 1 ])
		ifTrue: [ aSelection first first = 1
				ifTrue: [ mooseJobPresenter upButton disable ]
				ifFalse: [ mooseJobPresenter upButton enable ].
			aSelection first first = self model tasks size
				ifTrue: [ mooseJobPresenter downButton disable ]
				ifFalse: [ mooseJobPresenter downButton enable ] ]
		ifFalse: [ mooseJobPresenter upButton disable.
			mooseJobPresenter downButton disable ]
]

{ #category : #actions }
MooseTaskBrowser >> manageSettingDialog [
	self model input
		ifNotNil: [ runSettingPresenter inputText: self model input ].
	runSettingPresenter runnerList selectedIndex: self model runner order.
	runSettingPresenter openDialogWithSpec
		okAction: [ self model input: runSettingPresenter inputText text asString.
			self model runner: runSettingPresenter runnerList selectedItem.
			runSettingPresenter window close ]
]

{ #category : #actions }
MooseTaskBrowser >> manageTaskAddDialog [
	| items |
	items := mooseJobPresenter taskList selection selectedPaths.
	taskAdditionPresenter openDialogWithSpec
		okAction: [ | steps |
			steps := taskAdditionPresenter list selectedItems
				asOrderedCollection
				sort: [ :a :b | a description <= b description ].
			self model addTasks: steps.
			self model: self model.
			mooseJobPresenter taskList selection selectPaths: items.
			taskAdditionPresenter list unselectAll.
			taskAdditionPresenter window close ]
]

{ #category : #accessing }
MooseTaskBrowser >> modelChanged [
	mooseJobPresenter taskList roots: self model tasks.
	mooseJobPresenter taskList
		children: [ :aGroup | 
			aGroup class = MooseComposedTask
				ifTrue: [ aGroup tasks ]
				ifFalse: [ {} ] ];
		beResizable.
	change := true.
	self updateRuntimeList.
	self updateLogText.
	self model tasks
		ifEmpty: [ mooseJobPresenter upButton disable.
			mooseJobPresenter downButton disable.
			mooseJobPresenter runButton disable.
			mooseJobPresenter saveButton disable.
			mooseJobPresenter newJobButton disable ]
		ifNotEmpty: [ 
			mooseJobPresenter saveButton enable.
			mooseJobPresenter newJobButton enable.
			mooseJobPresenter runButton enable ].
	file
		ifNotNil: [ mooseJobPresenter saveButton enable.
			mooseJobPresenter newJobButton enable ]
]

{ #category : #accessing }
MooseTaskBrowser >> mooseJobPresenter [
	^ mooseJobPresenter
]

{ #category : #accessing }
MooseTaskBrowser >> mooseJobRuntimePresenter [
^mooseJobRuntimePresenter
]

{ #category : #actions }
MooseTaskBrowser >> newAnEmptyJob [
	self saveChangesDialog
		ifTrue: [ file := nil.
			self model: MooseJob new.
			self window title: 'Moose Task Browser' .mooseJobRuntimePresenter detailView text: 'Detail Display'.]
]

{ #category : #actions }
MooseTaskBrowser >> printDetail: item [
	item selectedItem ifNil: [ ^ self ].
	 mooseJobRuntimePresenter detailView text: item selectedItem printString
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

{ #category : #actions }
MooseTaskBrowser >> run [
	mooseJobRuntimePresenter detailView text: 'Detail Display'.
	self model runWithUpdatingBlock: [ self model: self model ].

]

{ #category : #accessing }
MooseTaskBrowser >> runSettingPresenter [
^runSettingPresenter
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
| index selection |
	selection := mooseJobPresenter taskList selection.
	index := (selection selectedPaths
		sort: [ :a :b | a first <= b first ]) first.
	self model separateTasks: selection selectedItems.
	self model: self model.
	selection selectPaths: {index}
]

{ #category : #'list control' }
MooseTaskBrowser >> swapItems: aNumber [
	| newSelectedPath |
	newSelectedPath := self model
		move: aNumber
		theTask: mooseJobPresenter taskList selection selectedItems first.
	self model: self model.
	mooseJobPresenter taskList selection
		selectPath: newSelectedPath asArray
]

{ #category : #accessing }
MooseTaskBrowser >> taskAdditionPresenter [
	^ taskAdditionPresenter
]

{ #category : #private }
MooseTaskBrowser >> uiManager [ 

	^ UIManager default
			
]

{ #category : #actions }
MooseTaskBrowser >> updateLogText [
	logView text: self model logger text
]

{ #category : #actions }
MooseTaskBrowser >> updateRuntimeList [
	mooseJobRuntimePresenter taskRuntimeList
		roots: (self model runtimeJobs ifNil: [ {} ]).
	mooseJobRuntimePresenter taskRuntimeList
		children: [ :aGroup | 
			aGroup class = MooseTaskRuntime
				ifTrue: [ {} ]
				ifFalse: [ aGroup tasks ] ];
		beResizable
]
