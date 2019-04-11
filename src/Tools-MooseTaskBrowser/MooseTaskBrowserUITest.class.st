Class {
	#name : #MooseTaskBrowserUITest,
	#superclass : #TestCase,
	#instVars : [
		'browser',
		'repository',
		'job'
	],
	#category : #'Tools-MooseTaskBrowser-tests'
}

{ #category : #action }
MooseTaskBrowserUITest >> addTasksFromRepository [
	browser addButton performAction.
	browser repositoryView listPresenter selectAll.
	browser repositoryView window triggerOkAction
]

{ #category : #setup }
MooseTaskBrowserUITest >> setUp [
	| task |
	repository := OrderedCollection new.
	(1 to: 2)
		do: [ :i | 
			task := MooseCustomTask new
				with: [ :v | v input asInteger + 2 ]
				description: '+2 Task'
				length: 0.
			repository add: task ].
	job := MooseJob new.
	browser := MooseTaskBrowser on: job.
	browser repositoryView setList: repository
]

{ #category : #tests }
MooseTaskBrowserUITest >> testAddTasksFromRepository [
	self assert: browser stepsDatasource elements size equals: 0.
	self addTasksFromRepository.
	self
		assert: browser stepsDatasource elements size
		equals: browser repositoryView listPresenter listItems size.
]

{ #category : #tests }
MooseTaskBrowserUITest >> testDownButtonNotEnabledWhenLastTaskIsSelected [
	self addTasksFromRepository.
	browser stepsDatasource
		setSelectedItems: (Array with: job tasks last).
	self assert: browser upButton enabled.
	self deny: browser downButton enabled
]

{ #category : #tests }
MooseTaskBrowserUITest >> testRepositoryViewDisplayedWhenAddButtonIsClicked [
	self deny: browser repositoryView isDisplayed.
	browser addButton performAction.
	self assert: browser repositoryView isDisplayed.
	browser repositoryView window close
]

{ #category : #tests }
MooseTaskBrowserUITest >> testSelectedTaskToMoveDownWhenDownButtonIsClicked [
	| temp |
	self addTasksFromRepository.
	browser stepsDatasource
		setSelectedItems: (Array with: job tasks second).
	temp := browser stepsDatasource selectedItems.
	browser upButton performAction.
	self assert: temp equals: (Array with: job tasks first).
	self assert: temp equals: browser stepsDatasource selectedItems
]

{ #category : #tests }
MooseTaskBrowserUITest >> testSelectedTaskToMoveUpWhenUpButtonIsClicked [
	| temp |
	self addTasksFromRepository.
	browser stepsDatasource
		setSelectedItems: (Array with: job tasks first).
	temp := browser stepsDatasource selectedItems.
	browser downButton performAction.
	self assert: temp equals: (Array with: job tasks second).
	self assert: temp equals: browser stepsDatasource selectedItems
]

{ #category : #tests }
MooseTaskBrowserUITest >> testSomeWidgetsEnabledWhenTheJobIsNotEmpty [
	self addTasksFromRepository.
	self deny: job tasks isEmpty.
	self assert: browser checkBox enabled.
	self assert: browser newJobButton enabled.
	self assert: browser saveButton enabled.
	self assert: browser runButton enabled
]

{ #category : #tests }
MooseTaskBrowserUITest >> testSomeWidgetsNotEnabledWhenTheJobIsEmpty [
	self assert: job tasks isEmpty.
	self deny: browser checkBox enabled.
	self deny: browser newJobButton enabled.
	self deny: browser saveButton enabled.
	self deny: browser upButton enabled.
	self deny: browser downButton enabled.
	self deny: browser runButton enabled
]

{ #category : #tests }
MooseTaskBrowserUITest >> testUpButtonNotEnabledWhenFirstTaskIsSelected [
	self addTasksFromRepository.
	browser stepsDatasource
		setSelectedItems: (Array with: job tasks first).
	self assert: browser downButton enabled.
	self deny: browser upButton enabled
]
