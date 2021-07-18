# Terraform Config cheatsheet
## Loops
### For_each
Creating multiple resources with for_each:

for_each_resources.tf

Creating multiple inline blocks:

for_each_inline_blocks.tf

### Count
```

```
Better in general to use for_each: count makes the resource addresses less readable and will recreate all the resources if you remove the first one in the array.
```

```
### For
Lists:
```

```
Maps:
```

```
### Splat
For resources created with count:
```

```
For resources created with for_each:
```

```
### For in strings (string directive)
```

```
## Ternary
```

```
## String interpolations (templating)
```

```
## JSON encoding
```

```
