import Autocomplete, { AutocompleteProps } from '@mui/material/Autocomplete'
import TextField from '@mui/material/TextField'
import React from 'react'
import { Controller, Control, Path } from 'react-hook-form'
import { CustomComponent, Option } from '../../core/types'
import { optionFrom } from '../../core/utils/object_utils'

export interface ControlledAutocompleteProps<T, K extends Path<T>, Multiple extends boolean = false>
  extends CustomComponent<Partial<AutocompleteProps<Option, Multiple, false, false>>> {
  control: Control<T>
  name: K
  options: Option[]
  helperText?: React.ReactNode
  placeholder?: string
  required?: boolean
  multiple?: Multiple
}

export const ControlledAutocomplete = <T, K extends Path<T>, Multiple extends boolean = false>(
  props: ControlledAutocompleteProps<T, K, Multiple>,
) => {
  const { control, name, options, helperText, placeholder, onChange, multiple, ...rest } = props

  const _value = React.useMemo(
    (): Multiple extends true ? Option<string>[] : Option<string> | null =>
      control._formValues[name]
        ? multiple
          ? control._formValues[name].map(optionFrom)
          : optionFrom(control._formValues[name])
        : multiple
        ? []
        : null,
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [control._formValues[name]],
  )
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const [value, setValue] = React.useState(_value ?? (multiple ? ([] as string[]) : ('' as any)))
  React.useEffect(
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    () => setValue(_value ?? (multiple ? ([] as string[]) : ('' as any))),
    [_value, multiple],
  )

  return (
    <Controller<T, K>
      control={control}
      name={name}
      rules={{ required: props.required }}
      render={({ field, formState: { errors } }) => (
        <Autocomplete
          onChange={(e, d, r) => {
            setValue(d as typeof _value)
            field.onChange(Array.isArray(d) ? d.map((d) => d?.value) : d?.value)
            onChange?.(e, d, r)
          }}
          value={value}
          options={options}
          getOptionLabel={(opt) => opt?.label}
          isOptionEqualToValue={(opt, value) => opt.value === value.value}
          multiple={multiple}
          renderInput={(params) => (
            <TextField
              {...params}
              fullWidth
              placeholder={placeholder}
              helperText={helperText}
              // eslint-disable-next-line @typescript-eslint/no-explicit-any
              error={Boolean((errors as any)[name])}
            />
          )}
          {...rest}
        />
      )}
    />
  )
}
