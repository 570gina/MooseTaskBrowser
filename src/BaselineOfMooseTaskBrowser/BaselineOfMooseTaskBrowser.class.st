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
		do: [ "Dependency"
			self mooseTaskBrowser: spec.

			"Package"
			spec package: 'Tools-MooseTaskBrowser' ]
]

{ #category : #baseline }
BaselineOfMooseTaskBrowser >> mooseTaskBrowser: spec [
	spec
		baseline: 'MooseTaskBrowser'
		with: [ spec
				repository: 'github://570gina/MooseTaskBrowser/tree/master/src' ]
]

{ #category : #accessing }
BaselineOfMooseTaskBrowser >> projectClass [
	 ^  MetacelloCypressBaselineProject
]
