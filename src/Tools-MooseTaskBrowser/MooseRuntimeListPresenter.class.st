Class {
	#name : #MooseRuntimeListPresenter,
	#superclass : #ComposablePresenter,
	#instVars : [
		'taskRuntimeList',
		'detailView'
	],
	#category : #'Tools-MooseTaskBrowser-Core-ui'
}

{ #category : #specs }
MooseRuntimeListPresenter class >> defaultSpec [
	^ SpecPanedLayout newVertical
		position: 75 percent;
		add: #taskRuntimeList;
		add: #detailView;yourself
]

{ #category : #'instance creation' }
MooseRuntimeListPresenter class >> open [
	<script>
	self new openWithSpec
]

{ #category : #accessing }
MooseRuntimeListPresenter >> detailView [
^detailView
]

{ #category : #initialization }
MooseRuntimeListPresenter >> initializeWidgets [
	taskRuntimeList := self newTreeTable .
	taskRuntimeList
		addColumn:
			(CompositeTableColumn new
				title: 'State';
				addColumn:
					(ImageTableColumn new
						width: 20;
						evaluated: #icon;
						yourself);
				addColumn:
					(StringTableColumn new
						evaluated: #description;
						yourself)).
	detailView := self newText disable.
	detailView text: 'Detail Display'.
	self focusOrder
		add: taskRuntimeList;
		add: detailView
]

{ #category : #accessing }
MooseRuntimeListPresenter >> taskRuntimeList [
	^ taskRuntimeList
]

{ #category : #event }
MooseRuntimeListPresenter >> whenTaskRuntimeListSelectionChanged: aBlock [
taskRuntimeList whenSelectionChangedDo: aBlock
]
