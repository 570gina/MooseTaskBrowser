"
|task taskRepo test|
taskRepo := MooseTaskRepository new.
task := MooseCustomTaskWithContext new 
        with: [ :v | v context: 100 atRandom. (1 to: 30000000) do: [ :i | true ] displayingProgress: 'running task: ', v description, ' with context ' , v context asString. v context +1  ]
        description: 'a description 1'
        length: 0.
taskRepo addTask: task.
task := MooseCustomTaskWithContext new
        with: [ :v | (1 to: 30000000) do: [ :i | true ] displayingProgress: 'running task: ', v description, ' with context ' , v context asString. v context + 1 ]
        description: 'a description 2'
        length: 0.
taskRepo addTask: task.
task := MooseCustomTaskWithContext new
        with: [ :v | (1 to: 30000000) do: [ :i | true ] displayingProgress: 'running task: ', v description, ' with context ' , v context asString. v context + 1  ]
        description: 'a description 3'
        length: 0.
taskRepo addTask: task.
task := MooseCustomTaskWithContext new
        with: [ :v | (1 to: 30000000) do: [ :i | true ] displayingProgress: 'running task: ', v description, ' with context ' , v context asString. v context + 1  ]
        description: 'a description 4'
        length: 0.
taskRepo addTask: task.
test := self new.
test repositoryView setList: taskRepo tasks.

test openWithSpec.
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
		'repositoryView'
	],
	#category : #'Tools-MooseTaskBrowser'
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
				ifFalse: [ self inform: 'Tasks stop.' ]
				ifTrue: [ self inform: 'Tasks finish.' ].
			state := false.
			listPresenter resetSelection ].
	addButton
		action: [ repositoryView openDialogWithSpec
				okAction: [ self
						setTasks: repositoryView listPresenter selectedItems asOrderedCollection ].
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
	| index nextInput |
	index := listPresenter getIndex.
	index to: listPresenter listSize do: [ :i | 
		listPresenter setIndex: i.
		nextInput
			ifNotNil: [ listPresenter selectedItem context: nextInput ].
		nextInput := [ listPresenter selectedItem run ]
			on: Exception
			do: [ :e | 
				| view |
				view := ExceptionDialog new.
				view
					messageText:
						('Task: ' , listPresenter selectedItem description , '\'
							, e description) withCRs.
				view openDialogWithSpec cancelAction: [ view window close.^ false ].
				view window modalRelativeTo: World ] ].
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
		ifNotNil: [ aCollection do: [ :i | (list includes: i) ifFalse:[ list add: i ] ]].
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
	listPresenter setSelectedItem: tempItem
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
