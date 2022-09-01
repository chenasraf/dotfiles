import React from 'react'
import flatsApi from '../../core/api/flats.api'
import { Flat } from '../../core/models/flats'
import { createUseApi } from '../../core/utils/react_utils'

export const useMyFlat = createUseApi(() => flatsApi.getMyFlat(), {
  cacheKey: 'myFlat',
  responseKey: 'flat',
})

export const usePotentialFlats = createUseApi(() => flatsApi.getPotentialFlatsList(), {
  cacheKey: 'potentialFlats',
  responseKey: 'potentialFlats',
  innerKey: 'flat',
})

export const useMatchedFlats = createUseApi(() => flatsApi.getMatchedFlatsList(), {
  cacheKey: 'matchedFlats',
  responseKey: 'fullMatches',
  innerKey: 'matchesByUser',
})

export const useLikedFlats = createUseApi(() => flatsApi.getLikedFlatsList(), {
  cacheKey: 'likedFlats',
  responseKey: 'likedFlats',
  innerKey: 'flat',
})

export const useDislikedFlats = createUseApi(() => flatsApi.getDislikedFlatsList(), {
  cacheKey: 'dislikedFlats',
  responseKey: 'dislikedFlats',
  innerKey: 'flat',
})

export function useFlatCache(list: Flat[] | undefined) {
  const [cache, setCache] = React.useState<Flat[]>(list ?? [])

  React.useEffect(() => {
    setCache(list ?? [])
  }, [list])

  return {
    data: cache,
    add: (item: Flat) => {
      setCache([...cache, item])
    },
    update: (item: Flat) => {
      setCache(cache.map((flat) => (flat.userId === item.userId ? item : flat)))
    },
    remove: (item: Flat) => {
      setCache(cache.filter((flat) => flat.userId !== item.userId))
    },
  }
}
