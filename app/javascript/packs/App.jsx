import React from "react"
import { BrowserRouter, Route, Routes } from "react-router-dom"
import Home from "../components/Home"
import Login from "../components/session/login"
import SignUp from "../components/session/signUp"

export default function App() {
  return(
    <BrowserRouter>
      <Routes>
        <Route path='/' element={<Home/>}/>

        <Route path='session'>
          <Route path='login' element={<Login/>}/>
          <Route path='signup' element={<SignUp/>}/>
        </Route>
        
      </Routes>
    </BrowserRouter>
  )
}
