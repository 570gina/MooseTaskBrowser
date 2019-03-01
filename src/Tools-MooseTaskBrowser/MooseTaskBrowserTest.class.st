Class {
	#name : #MooseTaskBrowserTest,
	#superclass : #TestCase,
	#instVars : [
		'ui'
	],
	#category : #'Tools-MooseTaskBrowser'
}

{ #category : #running }
MooseTaskBrowserTest >> setUp [
	"Hooks that subclasses may override to define the fixture of test."

	|task tasks|
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
ui := MooseTaskBrowser new.
ui tasks: tasks
]

{ #category : #tests }
MooseTaskBrowserTest >> testRunButtonEnabledWhenSelectedTask [
	ui list setIndex: 1.
	self assert: ui runButton enabled.
	ui list setIndex: 2.
	self assert: ui runButton enabled
]

{ #category : #tests }
MooseTaskBrowserTest >> testRunButtonNotEnabledWhenNoSelectedTask [
	ui list resetSelection.
	self deny: ui runButton enabled
]
