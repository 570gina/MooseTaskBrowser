"
|task tasks test|
tasks := OrderedCollection new.
task := MooseCustomTask new
		with: [ :v | true ]
		description: 'a description'
		length: 0.
tasks add: task.
task := MooseCustomTask new
		with: [ :v | true ]
		description: 'a description 2'
		length: 0.
tasks add: task.
task := MooseCustomTask new
		with: [ :v | true ]
		description: 'a description 3'
		length: 0.
tasks add: task.
test := self new.
test tasks: tasks.
test openWithSpec.
"
Class {
	#name : #MooseTaskBrowser,
	#superclass : #ComposablePresenter,
	#instVars : [
		'list',
		'saveButton',
		'loadButton',
		'addButton',
		'sortUpButton',
		'sortDownButton',
		'runButton',
		'selectedTask'
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
				add: #list;
				newColumn: [ :col | 
					col
						add: #sortUpButton;
						add: #sortDownButton ]
					width: self defaultFont height + 6 ];
		newRow: [ :row | row add: #runButton ] height: self toolbarHeight;
		yourself
]

{ #category : #accessing }
MooseTaskBrowser >> addButton [
	^ addButton
]

{ #category : #api }
MooseTaskBrowser >> extent [
	^ 300 @ 400
]

{ #category : #initialization }
MooseTaskBrowser >> initializePresenter [
	list
		whenSelectedItemChanged: [ :item | 
			| size |
			size := list listSize.
			item
				ifNil: [ runButton disable.
					sortUpButton disable.
					sortDownButton disable ]
				ifNotNil: [ runButton enable.
					size > 1
						ifTrue: [ sortUpButton enable.
							sortDownButton enable.
							list getIndex = 1
								ifTrue: [ sortUpButton disable ].
							list getIndex = size
								ifTrue: [ sortDownButton disable ] ] ] ].
	sortUpButton action: [ list setSelectedIndex: list selectedIndex - 1 ].
	sortDownButton action: [  ]
]

{ #category : #initialization }
MooseTaskBrowser >> initializeWidgets [
	list := self newList.
	loadButton := self newButton
		label: 'Load';
		icon: (self iconNamed: #smallOpen).
	saveButton := self newButton
		label: 'Save';
		icon: (self iconNamed: #glamorousSave).
	addButton := self newButton
		label: 'Add';
		icon: (self iconNamed: #smallAdd).
	sortUpButton := self newButton icon: (self iconNamed: #up).
	sortDownButton := self newButton
		icon: (self iconNamed: #down).
	runButton := self newButton
		label: 'Run';
		icon: (self iconNamed: #smallDoIt).
	self focusOrder
		add: loadButton;
		add: saveButton;
		add: addButton;
		add: sortUpButton;
		add: sortDownButton;
		add: list;
		add: runButton
]

{ #category : #accessing }
MooseTaskBrowser >> list [
	^ list
]

{ #category : #accessing }
MooseTaskBrowser >> loadButton [
	^ loadButton
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
	^ list selectedItem
]

{ #category : #accessing }
MooseTaskBrowser >> sortDownButton [
	^ sortDownButton
]

{ #category : #accessing }
MooseTaskBrowser >> sortUpButton [
	^ sortUpButton
]

{ #category : #accessing }
MooseTaskBrowser >> tasks: aCollection [
	list
		items: aCollection;
		displayBlock: [:task | task description] 
]

{ #category : #api }
MooseTaskBrowser >> title [ 
	^'Moose Tasks'
]
