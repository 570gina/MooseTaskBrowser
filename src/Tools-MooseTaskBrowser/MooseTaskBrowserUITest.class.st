Class {
	#name : #MooseTaskBrowserUITest,
	#superclass : #TestCase,
	#instVars : [
		'browser',
		'repository',
		'job',
		'mooseJobPresenter'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #action }
MooseTaskBrowserUITest >> addTasksFromRepository [
	mooseJobPresenter addButton performAction.
	browser repositoryWindow list selectAll.
	browser repositoryWindow window triggerOkAction
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
	browser repositoryWindow list items: repository.
	mooseJobPresenter := browser mooseJob
]

{ #category : #tests }
MooseTaskBrowserUITest >> testDownButtonNotEnabledWhenLastTaskIsSelected [
	self addTasksFromRepository.
	browser stepsDatasource
		setSelectedItems: (Array with: job tasks last).
	self assert: mooseJobPresenter upButton isEnabled.
	self deny: mooseJobPresenter downButton isEnabled
]

{ #category : #tests }
MooseTaskBrowserUITest >> testRepositoryViewDisplayedWhenAddButtonIsClicked [
	self deny: browser repositoryWindow isDisplayed.
	mooseJobPresenter addButton performAction.
	self assert: browser repositoryWindow isDisplayed.
	browser repositoryWindow window close
]

{ #category : #tests }
MooseTaskBrowserUITest >> testSelectedTaskToMoveDownWhenDownButtonIsClicked [
	| temp |
	self addTasksFromRepository.
	browser stepsDatasource
		setSelectedItems: (Array with: job tasks second).
	temp := browser stepsDatasource selectedItems.
	mooseJobPresenter upButton performAction.
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
	mooseJobPresenter downButton performAction.
	self assert: temp equals: (Array with: job tasks second).
	self assert: temp equals: browser stepsDatasource selectedItems
]

{ #category : #tests }
MooseTaskBrowserUITest >> testSomeWidgetsEnabledWhenTheJobIsNotEmpty [
	self addTasksFromRepository.
	self deny: job tasks isEmpty.
	self assert: mooseJobPresenter newJobButton isEnabled.
	self assert: mooseJobPresenter saveButton isEnabled.
	self assert: mooseJobPresenter runButton isEnabled
]

{ #category : #tests }
MooseTaskBrowserUITest >> testSomeWidgetsNotEnabledWhenTheJobIsEmpty [
	self assert: job tasks isEmpty.
	self deny: mooseJobPresenter newJobButton isEnabled.
	self deny: mooseJobPresenter saveButton isEnabled.
	self deny: mooseJobPresenter upButton isEnabled.
	self deny: mooseJobPresenter downButton isEnabled.
	self deny: mooseJobPresenter runButton isEnabled
]

{ #category : #tests }
MooseTaskBrowserUITest >> testUpButtonNotEnabledWhenFirstTaskIsSelected [
	self addTasksFromRepository.
	browser stepsDatasource
		setSelectedItems: (Array with: job tasks first).
	self assert: mooseJobPresenter downButton isEnabled.
	self deny: mooseJobPresenter upButton isEnabled
]
