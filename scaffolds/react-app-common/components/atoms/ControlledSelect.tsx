import Select, { SelectProps } from '@mui/material/Select'
import MenuItem from '@mui/material/MenuItem'
import React from 'react'
import { Controller, Control, Path } from 'react-hook-form'
import { CustomComponent, Option } from 'core/types'
import { useRerender } from 'core/utils/react_utils'

export interface ControlledSelectProps<
  R extends string,
  T,
  K extends Path<T>,
  Multiple extends boolean = false,
> extends CustomComponent<Partial<SelectProps<R>>> {
  control: Control<T>
  name: K
  options: Option<R>[]
  helperText?: React.ReactNode
  placeholder?: string
  required?: boolean
  multiple?: Multiple
}

export const ControlledSelect = <
  R extends string,
  T,
  K extends Path<T>,
  Multiple extends boolean = false,
>(
  props: ControlledSelectProps<R, T, K, Multiple>,
) => {
  const {
    control,
    name,
    options,
    // eslint-disable-next-line @typescript-eslint/no-unused-vars
    helperText,
    placeholder,
    onChange,
    multiple = false,
    ...rest
  } = props

  const _value = React.useMemo(
    (): typeof multiple extends true ? R[] : R | null =>
      (control._formValues[name]
        ? multiple
          ? (control._formValues[name] as R[]).map((x) => options.find((y) => y.value === x)!.value)
          : options.find((x) => x.value === control._formValues[name])!.value
        : multiple
        ? []
        : null) as typeof multiple extends true ? R[] : R | null,
    // eslint-disable-next-line react-hooks/exhaustive-deps
    [control._formValues[name], multiple, name, options],
  )
  const [value, setValue] = React.useState<string | string[]>(
    (Array.isArray(_value) ? _value : _value) ?? (multiple ? [] : ''),
  )
  React.useEffect(() => setValue(_value ?? (multiple ? [] : '')), [_value, multiple])
  const rerender = useRerender()

  return (
    <Controller<T, K>
      control={control}
      name={name}
      rules={ { required: props.required } }
      render={({ field, formState: { errors } }) => (
        <Select
          onChange={(e, d) => {
            const { value: changeValue } = e.target!
            if (!multiple) {
              field.onChange(changeValue)
              setValue(changeValue)
            } else {
              const valueArr = value as R[]
              const fieldValue = valueArr.includes(changeValue as unknown as R)
                ? valueArr.filter((x) => x !== changeValue)
                : [...valueArr, changeValue]
              field.onChange(fieldValue)
              setValue(fieldValue)
            }

            onChange?.(e, d)
            rerender()
          }}
          value={value as R}
          renderValue={
            ((v) =>
              Array.isArray(v)
                ? placeholder
                : options.find((x) => x.value === v)?.label ?? placeholder) as (
              value: string | string[],
            ) => React.ReactNode
          }
          // eslint-disable-next-line @typescript-eslint/no-explicit-any
          error={Boolean((errors as any)[name])}
          {...rest}
        >
          {options.map((opt) => (
            <MenuItem
              key={opt.value}
              value={opt.value}
              sx={
                Boolean(Array.isArray(value) ? value.includes(opt.value) : value === opt.value)
                  ? {
                      backgroundColor: (theme) => theme.palette.grey[200],
                    }
                  : undefined
              }
            >
              {opt.label}
            </MenuItem>
          ))}
        </Select>
      )}
    />
  )
}
