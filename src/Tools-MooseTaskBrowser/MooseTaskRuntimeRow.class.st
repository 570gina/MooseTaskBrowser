Class {
	#name : #MooseTaskRuntimeRow,
	#superclass : #ComposablePresenterWithModel,
	#instVars : [
		'items'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #initialization }
MooseTaskRuntimeRow >> initializeWidgets [
	items := self newPanel.
	self focusOrder
		add: items.
]
