import placesApi, { GetPlacesListResult } from '../../core/api/places.api'
import uniqBy from 'lodash/uniqBy'
import React from 'react'
import { createUseApi, RequiredQueryOptions } from '../../core/utils/react_utils'

export const usePlaces = createUseApi(() => placesApi.getPlacesList(), {
  cacheKey: 'places',
  responseKey: 'places',
})

export function useCities(options?: RequiredQueryOptions<GetPlacesListResult>) {
  const { places = [], ...rest } = usePlaces(options)
  const data = React.useMemo(() => uniqBy(places, 'city'), [places])
  return { ...rest, cities: data }
}

export function useNeighborhoods(options?: RequiredQueryOptions<GetPlacesListResult>) {
  const { places = [], ...rest } = usePlaces(options)
  const data = React.useMemo(() => uniqBy(places, 'neighborhood'), [places])
  return { ...rest, neighborhoods: data }
}
