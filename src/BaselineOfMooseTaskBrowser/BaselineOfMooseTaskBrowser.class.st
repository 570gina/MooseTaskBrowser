Class {
	#name : #BaselineOfMooseTaskBrowser,
	#superclass : #BaselineOf,
	#category : #BaselineOfMooseTaskBrowser
}

{ #category : #baseline }
BaselineOfMooseTaskBrowser >> baseline: spec [
	<baseline>
	spec
		for: #common
		do:
			[ "Dependency" "self mooseTaskBrowser: spec." "Package" "spec package: 'Tools-MooseTaskBrowser'" ]
]

{ #category : #accessing }
BaselineOfMooseTaskBrowser >> projectClass [
	 ^  MetacelloCypressBaselineProject
]
