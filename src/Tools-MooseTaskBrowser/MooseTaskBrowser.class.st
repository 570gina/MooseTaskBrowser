"
|task taskRepo test|
taskRepo := MooseTaskRepository new.
task := MooseCustomTask new
        with: [ :v | (1 to: 60000000) do: [ :i | true ] displayingProgress: 'running task: ', v description. true ]
        description: 'a description 1'
        length: 0.
taskRepo addTask: task.
task := MooseCustomTask new
        with: [ :v | (1 to: 60000000) do: [ :i | true ] displayingProgress: 'running task: ', v description. true ]
        description: 'a description 2'
        length: 0.
taskRepo addTask: task.
task := MooseCustomTask new
        with: [ :v | (1 to: 60000000) do: [ :i | true ] displayingProgress: 'running task: ', v description. true ]
        description: 'a description 3'
        length: 0.
taskRepo addTask: task.
task := MooseCustomTask new
        with: [ :v | (1 to: 60000000) do: [ :i | true ] displayingProgress: 'running task: ', v description. true ]
        description: 'a description 4'
        length: 0.
taskRepo addTask: task.
test := self new.
test setTaskRepo: taskRepo.
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
		'taskRepo'
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

{ #category : #accessing }
MooseTaskBrowser >> addButton [
	^ addButton
]

{ #category : #accessing }
MooseTaskBrowser >> downButton [
	^ downButton
]

{ #category : #api }
MooseTaskBrowser >> extent [
	^ 300 @ 400
]

{ #category : #initialization }
MooseTaskBrowser >> initializePresenter [
	listPresenter
		whenSelectedItemChanged: [ :item | 
			| size |
			size := listPresenter listSize.
			self isRunning
				ifTrue: [ runButton disable.upButton disable. downButton disable];
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
			self run ]
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWidgets [
	listPresenter := self newList.
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

{ #category : #actions }
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

{ #category : #actions }
MooseTaskBrowser >> run [
	| index |
	index := listPresenter getIndex.
	index to: listPresenter listSize do: [ :i | 
		listPresenter setIndex: i.
		self selectedTask run.
		Transcript
			show: self selectedTask description , ' start';
			cr ].
	state := false.
	listPresenter setSelectedItem: self selectedTask.
]

{ #category : #accessing }
MooseTaskBrowser >> runButton [
	^ runButton
]

{ #category : #accessing }
MooseTaskBrowser >> saveButton [
	^ saveButton
]

{ #category : #accessing }
MooseTaskBrowser >> selectedTask [
	^ listPresenter selectedItem
]

{ #category : #accessing }
MooseTaskBrowser >> setTaskRepo: aMooseTaskRepository [ 
	taskRepo := aMooseTaskRepository.
]

{ #category : #initialization }
MooseTaskBrowser >> setTasks: aCollection [
	list := aCollection.
	list ifNotNil: [  
	listPresenter
		items: list;
		displayBlock: [ :task | task description ]]
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

{ #category : #api }
MooseTaskBrowser >> title [ 
	^'Moose Tasks'
]

{ #category : #accessing }
MooseTaskBrowser >> upButton [
	^ upButton
]
