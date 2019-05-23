Class {
	#name : #MooseJobPresenterTest,
	#superclass : #MooseTaskBrowserUITest,
	#instVars : [
		'mooseJobPresenter',
		'taskAdditionPresenter',
		'runSettingPresenter'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #setup }
MooseJobPresenterTest >> setUp [
	super setUp.
	mooseJobPresenter := presenter mooseJobPresenter.
	taskAdditionPresenter := presenter taskAdditionPresenter.
	runSettingPresenter := presenter runSettingPresenter
]

{ #category : #tests }
MooseJobPresenterTest >> testAddButton [
	self deny:  taskAdditionPresenter isDisplayed.
	mooseJobPresenter addButton performAction.
	self assert:  taskAdditionPresenter isDisplayed.
	 taskAdditionPresenter window close
]

{ #category : #tests }
MooseJobPresenterTest >> testAddTasksFromTaskAdditionPresenter [
	self assert: mooseJobPresenter taskList roots isEmpty.
	self addTasks.
	self assert: mooseJobPresenter taskList roots isNotEmpty
]

{ #category : #tests }
MooseJobPresenterTest >> testSetInputForTheJob [
	self
		deny: presenter model input
		equals: '10'. mooseJobPresenter settingButton performAction.
	runSettingPresenter inputText: '10'.
	runSettingPresenter window triggerOkAction.
	self assert: presenter model input equals: '10'
]

{ #category : #tests }
MooseJobPresenterTest >> testSetRunnerForTheJob [
	mooseJobPresenter settingButton performAction.
	runSettingPresenter runnerList selectedIndex: 2.
	runSettingPresenter window triggerOkAction.
	self
		assert: presenter model runner class
		equals: runSettingPresenter runnerList listItems second class
]

{ #category : #tests }
MooseJobPresenterTest >> testSettingButton [
	self deny: runSettingPresenter isDisplayed.
	mooseJobPresenter settingButton performAction.
	self assert: runSettingPresenter isDisplayed.
	runSettingPresenter window close
]

{ #category : #tests }
MooseJobPresenterTest >> testSomeWidgetsEnabledWhenTheJobIsNotEmpty [
	self addTasks.
	self deny: job tasks isEmpty.
	self assert: mooseJobPresenter newJobButton isEnabled.
	self assert: mooseJobPresenter saveButton isEnabled.
	self assert: mooseJobPresenter runButton isEnabled
]

{ #category : #tests }
MooseJobPresenterTest >> testSomeWidgetsNotEnabledWhenTheJobIsEmpty [
	self assert: job tasks isEmpty.
	self deny: mooseJobPresenter newJobButton isEnabled.
	self deny: mooseJobPresenter saveButton isEnabled.
	self deny: mooseJobPresenter upButton isEnabled.
	self deny: mooseJobPresenter downButton isEnabled.
	self deny: mooseJobPresenter runButton isEnabled
]
