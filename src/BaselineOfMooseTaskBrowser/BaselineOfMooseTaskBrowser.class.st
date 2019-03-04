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
		do: [ spec preLoadDoIt: #verifyMooseInstalled.
			"Packages"
			spec package: 'Tools-MooseTaskBrowser' ]
]

{ #category : #accessing }
BaselineOfMooseTaskBrowser >> projectClass [
	 ^  MetacelloCypressBaselineProject
]

{ #category : #baseline }
BaselineOfMooseTaskBrowser >> verifyMooseInstalled [
	self class environment
		at: #MooseModel
		ifAbsent: [ UIManager default
						abort:
							'Moose must be installed prior to loading MooseTaskBrowser. The baseline doesn''t load it because it''s big. We recommend loading it from the GitHub repo, or starting with a Moose image from Pharo Launcher.' ]
]
