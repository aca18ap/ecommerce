$('#email').on('input', function(){
    console.log('hj')
    updateSubmit()
})

function updateSubmit(){
    let email = document.getElementById('email').textContent
    let sbt = document.getElementById('submit_button')
    console.log('l')
    if (ValidateEmail(email)){
        sbt.disabled = true
    }else{
        sbt.disabled = false
    }
}

function ValidateEmail(email) 
{
 if (/^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/.test(email))
  {
    return (true)
  }
    return (false)
}