# Task Schema

```txt
/uk.gov.education/rsd/cctc/section#/properties/tasks/items
```

A task on the task list, which contains one or more actions.

| Abstract            | Extensible | Status         | Identifiable | Custom Properties | Additional Properties | Access Restrictions | Defined In                                                                                      |
| :------------------ | :--------- | :------------- | :----------- | :---------------- | :-------------------- | :------------------ | :---------------------------------------------------------------------------------------------- |
| Can be instantiated | No         | Unknown status | No           | Forbidden         | Forbidden             | none                | [section.schema.json\*](../../app/workflows/schemas/section.schema.json "open original schema") |

## items Type

`object` ([Task](section-properties-tasks-task.md))

# items Properties

| Property                               | Type      | Required | Nullable       | Defined by                                                                                                                                                       |
| :------------------------------------- | :-------- | :------- | :------------- | :--------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [slug](#slug)                          | `string`  | Required | cannot be null | [Section](section-properties-tasks-task-properties-slug.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/slug")                         |
| [title](#title)                        | `string`  | Required | cannot be null | [Section](section-properties-tasks-task-properties-title.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/title")                       |
| [hint](#hint)                          | `string`  | Optional | cannot be null | [Section](section-properties-tasks-task-properties-hint.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/hint")                         |
| [guidance\_summary](#guidance_summary) | `string`  | Optional | cannot be null | [Section](section-properties-tasks-task-properties-guidance-summary.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/guidance_summary") |
| [guidance\_text](#guidance_text)       | `string`  | Optional | cannot be null | [Section](section-properties-tasks-task-properties-guidance-text.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/guidance_text")       |
| [optional](#optional)                  | `boolean` | Optional | cannot be null | [Section](section-properties-tasks-task-properties-optional.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/optional")                 |
| [actions](#actions)                    | `array`   | Required | cannot be null | [Section](section-properties-tasks-task-properties-actions.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions")                   |

## slug

A unique human-readable string which identifies this task.

`slug`

*   is required

*   Type: `string` ([Slug](section-properties-tasks-task-properties-slug.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-slug.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/slug")

### slug Type

`string` ([Slug](section-properties-tasks-task-properties-slug.md))

### slug Constraints

**pattern**: the string must match the following regular expression:&#x20;

```regexp
^[a-z0-9-]+$
```

[try pattern](https://regexr.com/?expression=%5E%5Ba-z0-9-%5D%2B%24 "try regular expression with regexr.com")

### slug Examples

```yaml
handover-with-rdo

```

```yaml
clear-and-sign-church-supplemental-agreement

```

## title



`title`

*   is required

*   Type: `string` ([Title](section-properties-tasks-task-properties-title.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-title.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/title")

### title Type

`string` ([Title](section-properties-tasks-task-properties-title.md))

## hint

A short hint to explain to users what this task achieves.

`hint`

*   is optional

*   Type: `string` ([Hint](section-properties-tasks-task-properties-hint.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-hint.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/hint")

### hint Type

`string` ([Hint](section-properties-tasks-task-properties-hint.md))

## guidance\_summary

A summary of the guidance available when the user expands the guidance section.

`guidance_summary`

*   is optional

*   Type: `string` ([Guidance summary](section-properties-tasks-task-properties-guidance-summary.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-guidance-summary.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/guidance_summary")

### guidance\_summary Type

`string` ([Guidance summary](section-properties-tasks-task-properties-guidance-summary.md))

## guidance\_text

The text to include within the guidance drop-down section for this task.

`guidance_text`

*   is optional

*   Type: `string` ([Guidance text](section-properties-tasks-task-properties-guidance-text.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-guidance-text.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/guidance_text")

### guidance\_text Type

`string` ([Guidance text](section-properties-tasks-task-properties-guidance-text.md))

## optional

If the entire task can be considered optional (in which case a "not applicable" option will appear), or if it's mandatory.

`optional`

*   is optional

*   Type: `boolean` ([Optional](section-properties-tasks-task-properties-optional.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-optional.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/optional")

### optional Type

`boolean` ([Optional](section-properties-tasks-task-properties-optional.md))

## actions

A list of actions which collectively make up a task.

`actions`

*   is required

*   Type: `object[]` ([Action](section-properties-tasks-task-properties-actions-action.md))

*   cannot be null

*   defined in: [Section](section-properties-tasks-task-properties-actions.md "/uk.gov.education/rsd/cctc/section#/properties/tasks/items/properties/actions")

### actions Type

`object[]` ([Action](section-properties-tasks-task-properties-actions-action.md))

### actions Constraints

**minimum number of items**: the minimum number of items for this array is: `1`
