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
		'listPresenter',
		'saveButton',
		'loadButton',
		'addButton',
		'upButton',
		'downButton',
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
			item
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
								ifTrue: [ downButton disable ] ] ] ].
	upButton action: [ self swapItems: -2 ].
	downButton action: [ self swapItems: 0 ]
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
	self focusOrder
		add: loadButton;
		add: saveButton;
		add: addButton;
		add: upButton;
		add: downButton;
		add: listPresenter;
		add: runButton
]

{ #category : #accessing }
MooseTaskBrowser >> listPresenter [
	^ listPresenter
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
	^ listPresenter selectedItem
]

{ #category : #'list control' }
MooseTaskBrowser >> swapItems: aNumber [
	| list selectedIndex tempItem |
	list := listPresenter listItems.
	selectedIndex := listPresenter getIndex.
	tempItem := list at: selectedIndex.
	list removeAt: selectedIndex.
	list add: tempItem afterIndex: selectedIndex + aNumber.
	listPresenter items: list.
	listPresenter setSelectedItem: tempItem.
]

{ #category : #accessing }
MooseTaskBrowser >> tasks: aCollection [
	listPresenter
		items: aCollection;
		displayBlock: [ :task | task description ]
]

{ #category : #api }
MooseTaskBrowser >> title [ 
	^'Moose Tasks'
]

{ #category : #accessing }
MooseTaskBrowser >> upButton [
	^ upButton
]
