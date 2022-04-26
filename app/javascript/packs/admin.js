$('#email').on('input', function(){
    updateSubmit()
})

function updateSubmit(){
    let email = document.getElementById('email').textContent
    let sbt = document.getElementById('submit_button')
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