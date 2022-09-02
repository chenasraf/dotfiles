import React from 'react'
import Box from '@mui/material/Box'
import Image from '{{ imageImport }}'
import Typography from '@mui/material/Typography'
import Link from '@mui/material/Link'
import logo from './logo.svg'

function App() {
  return (
    <Box sx={ { textAlign: 'center' } }>
      <Box 
        component="header" 
        sx={ {
          backgroundColor: "#282c34",
          minHeight: "100vh",
          display: "flex",
          flexDirection: "column",
          alignItems: "center",
          justifyContent: "center",
          fontSize: "calc(10px + 2vmin)",
          color: "white",
        } }>
        <Image
          src={logo}
          alt="logo"
          sx={ {
            height: "40vmin",
            pointerEvents: "none",
            animation: "App-logo-spin infinite 20s linear",
            "@keyframes App-logo-spin": {
              from: {
                transform: "rotate(0deg)",
              },
              to: {
                transform: "rotate(360deg)",
              }
            }
          } } />
        <Typography>
          Edit <code>src/App.tsx</code> and save to reload.
        </Typography>
        <Link
          sx={ { color: "#61dafb" } }
          href="https://reactjs.org"
          target="_blank"
          rel="noopener noreferrer"
        >
          Learn React
        </Link>
      </Box>
    </Box>
  )
}

export default App
