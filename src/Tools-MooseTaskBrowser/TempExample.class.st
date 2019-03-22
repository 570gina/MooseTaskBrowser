"
TempExample new openWithSpec
"
Class {
	#name : #TempExample,
	#superclass : #ComposablePresenter,
	#instVars : [
		'taskTreePresenter',
		'button2',
		'button1',
		'selectedItem'
	],
	#category : #'Tools-MooseTaskBrowser-core'
}

{ #category : #specs }
TempExample class >> defaultSpec [
	^ SpecColumnLayout composed
		add: #taskTreePresenter;
		add: #button1 height: self toolbarHeight;
		add: #button2 height: self toolbarHeight;
		yourself
]

{ #category : #accessing }
TempExample >> button1 [
	^ button1
]

{ #category : #accessing }
TempExample >> button2 [
	^ button2
]

{ #category : #initialization }
TempExample >> initializePresenter [
	button1
		action: [ selectedItem := taskTreePresenter selectedItems.
			taskTreePresenter deselectAll ].
	button2
		action: [ 
			selectedItem do: [ : s | taskTreePresenter
				selectedItem: s ].
			 taskTreePresenter
				selectionChanged.
			taskTreePresenter updateTree ]
]

{ #category : #initialization }
TempExample >> initializeWidgets [
	button1 := self newButton.
	button2 := self newButton.
	taskTreePresenter := self newTree beCheckList.
	taskTreePresenter autoMultiSelection: true.
	taskTreePresenter roots: #(a b c d).
	self focusOrder
		add: taskTreePresenter;
		add: button1;
		add: button2
]

{ #category : #accessing }
TempExample >> selectedItem [
^selectedItem
]

{ #category : #accessing }
TempExample >> taskTreePresenter [
	^ taskTreePresenter
]

{ #category : #accessing }
TempExample >> taskTreePresenter: anObject [
	taskTreePresenter := anObject
]
