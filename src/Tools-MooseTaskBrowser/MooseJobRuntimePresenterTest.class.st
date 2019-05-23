Class {
	#name : #MooseJobRuntimePresenterTest,
	#superclass : #MooseTaskBrowserUITest,
	#instVars : [
		'mooseJobRuntimePresenter'
	],
	#category : #'Tools-MooseTaskBrowser-Tests'
}

{ #category : #setup }
MooseJobRuntimePresenterTest >> setUp [ 
super setUp
.
	mooseJobRuntimePresenter := presenter mooseJobRuntimePresenter.
]
