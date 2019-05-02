Class {
	#name : #MooseJobPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'newJobButton',
		'loadButton',
		'saveButton',
		'addButton',
		'upButton',
		'downButton',
		'settingButton',
		'runButton',
		'taskList'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
MooseJobPresenter class >> defaultSpec [
	^SpecBoxLayout newVertical
		add:
			(SpecBoxLayout newHorizontal
				add: #newJobButton;
				add: #loadButton;
				add: #saveButton;
				add: #addButton)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		add:
			(SpecBoxLayout newHorizontal
				add: #taskList;
				add:
					(SpecBoxLayout newVertical
						add: #upButton;
						add: #downButton)
					withConstraints: [ :constraints | constraints width: self defaultFont height + 6 ]);
		add:
			(SpecBoxLayout newHorizontal
				add: #settingButton
					withConstraints: [ :constraints | constraints width: self toolbarHeight ];
				add: #runButton)
			withConstraints: [ :constraints | constraints height: self toolbarHeight ];
		yourself
]

{ #category : #'instance creation' }
MooseJobPresenter class >> open [
	<script>
	self new openWithSpec
]

{ #category : #accessing }
MooseJobPresenter >> addButton [
	^ addButton
]

{ #category : #accessing }
MooseJobPresenter >> downButton [
	^ downButton
]

{ #category : #initialization }
MooseJobPresenter >> initializeWidgets [
	taskList := self newTreeTable beMultipleSelection.
	taskList
		addColumn:
			(StringTableColumn new
				title: 'Moose Job';
				evaluated: #description;
				yourself).
	newJobButton := self newButton
		label: 'New';
		icon: (self iconNamed: #page).
	loadButton := self newButton
		label: 'Load';
		icon: (self iconNamed: #smallOpen).
	saveButton := self newButton
		label: 'Save';
		icon: (self iconNamed: #glamorousSave).
	addButton := self newButton
		label: 'Add Tasks';
		icon: (self iconNamed: #smallAdd).
	upButton := self newButton icon: (self iconNamed: #up).
	downButton := self newButton icon: (self iconNamed: #down).
	settingButton := self newButton
		icon: (self iconNamed: #smallConfiguration).
	runButton := self newButton
		label: 'Run';
		icon: (self iconNamed: #smallDoIt).
	self focusOrder
		add: newJobButton;
		add: loadButton;
		add: saveButton;
		add: addButton;
		add: upButton;
		add: downButton;
		add: taskList;
		add: settingButton;
		add: runButton
]

{ #category : #accessing }
MooseJobPresenter >> loadButton [
	^ loadButton
]

{ #category : #accessing }
MooseJobPresenter >> newJobButton [
	^ newJobButton
]

{ #category : #accessing }
MooseJobPresenter >> runButton [
^runButton

]

{ #category : #accessing }
MooseJobPresenter >> saveButton [
	^ saveButton
]

{ #category : #accessing }
MooseJobPresenter >> taskList [
	^ taskList
]

{ #category : #accessing }
MooseJobPresenter >> upButton [
	^ upButton
]

{ #category : #event }
MooseJobPresenter >> whenAddButtonIsClicked: aBlock [
	addButton action: aBlock
]

{ #category : #event }
MooseJobPresenter >> whenDownButtonIsClicked: aBlock [
	downButton action: aBlock
]

{ #category : #event }
MooseJobPresenter >> whenLoadButtonIsClicked: aBlock [
	loadButton action: aBlock
]

{ #category : #event }
MooseJobPresenter >> whenNewJobButtonIsClicked: aBlock [
	newJobButton action: aBlock
]

{ #category : #event }
MooseJobPresenter >> whenRunButtonIsClicked: aBlock [
	runButton action: aBlock
]

{ #category : #event }
MooseJobPresenter >> whenSaveButtonIsClicked: aBlock [
	saveButton action: aBlock
]

{ #category : #event }
MooseJobPresenter >> whenSettingButtonIsClicked: aBlock [
	settingButton action: aBlock
]

{ #category : #event }
MooseJobPresenter >> whenTaskListSelectionChanged: aBlock [
	taskList whenMultiSelectionChangedDo: aBlock
]

{ #category : #event }
MooseJobPresenter >> whenUpButtonIsClicked: aBlock [
	upButton action:aBlock
	
]
