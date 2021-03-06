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
		'taskList',
		'menu'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
MooseJobPresenter class >> defaultSpec [
	^ SpecBoxLayout newVertical
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
MooseJobPresenter >> initialize [
	self initializeMenu.
	super initialize
]

{ #category : #initialization }
MooseJobPresenter >> initializeMenu [
	menu := self newMenu.
]

{ #category : #initialization }
MooseJobPresenter >> initializeWidgets [
	taskList := self newTreeTable beMultipleSelection;contextMenu: self menu.
	taskList
		addColumn:
			(StringTableColumn new
				title: 'Moose Job';
				evaluated: #description;
				yourself).
	newJobButton := self newButton
		label: 'Create';
		icon: (self iconNamed: #page);
		help: 'Create a new empty job.'.
	loadButton := self newButton
		label: 'Load';
		icon: (self iconNamed: #smallOpen);
		help: 'Load an existing job.'.
	saveButton := self newButton
		label: 'Save ';
		icon: (self iconNamed: #glamorousSave);
		help: 'Save the current job.'.
	addButton := self newButton
		label: 'Add Tasks';
		icon: (self iconNamed: #smallAdd);
		help: 'Add tasks to the current job.'.
	upButton := self newButton
		icon: (self iconNamed: #up);
		help: 'Move the selected task up.'.
	downButton := self newButton
		icon: (self iconNamed: #down);
		help: 'Move the selected task down.'.
	settingButton := self newButton
		icon: (self iconNamed: #smallConfiguration);
		help: 'Set the input and select a runner.'.
	runButton := self newButton
		label: 'Run';
		icon: (self iconNamed: #smallDoIt);
		help: 'Run the current job.'.
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

{ #category : #action }
MooseJobPresenter >> inspectSelectedItem [
	taskList selection selectedItems size = 1
		ifTrue: [ taskList selection selectedItems first inspect ].
			taskList selection selectedItems size > 1
		ifTrue: [ taskList selection selectedItems  inspect ]
]

{ #category : #action }
MooseJobPresenter >> isRoot [
	^ taskList selection selectedPaths first size = 1 
]

{ #category : #accessing }
MooseJobPresenter >> loadButton [
	^ loadButton
]

{ #category : #accessing }
MooseJobPresenter >> menu [
	^menu
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
MooseJobPresenter >> settingButton [
^settingButton
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
