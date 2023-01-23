
<html>

<body>
    <form onsubmit="SaveToLocalStorage(event)">
        <label>Name</label>
        <input type="text" name="usename" required/>
        <label>EmailId</label>
        <input type="email" name="emailid"  required/>
        <label>PhoneNumber</label>
        <input type="tel" name="phonenumber"/>
    
        <button>Submit</button>
        <br />

    </form>
    <ul id="listitem"></ul>
    <script>

        function SaveToLocalStorage(event){
            event.preventDefault();
        const name=event.target.usename.value
        const ema=event.target.emailid.value
        const phonen=event.target.phonenumber.value
        // localStorage.setItem('name',name)
        // localStorage.setItem('ema',ema)
        // localStorage.setItem('phonen',phonen)
const obj={
    name,
    ema,
    phonen
    
}
localStorage.setItem(obj.ema,JSON.stringify(obj))
 adddetail(obj)
        }

        function adddetail(obj){
            const parentElement=document.getElementById('listitem')
           const chiledelement=document.createElement('li')
            //if we have replace
         
            // parentElement.innerHTML=`${obj.name} - ${obj.ema} - ${obj.phonen} `
    
            //parentElement.innerHTML=parentElement.innerHTML+`${obj.name} - ${obj.ema} - ${obj.phonen} `

          chiledelement.textContent=`${obj.name} - ${obj.ema} - ${obj.phonen} `
         parentElement.appendChild(chiledelement)

          const deletebutton=document.createElement('input')
 deletebutton.type="button"
 deletebutton.value='Delete'

 deletebutton.onclick=() =>{
     localStorage.removeItem(obj.ema)
    parentElement.removeChild(chiledelement)
 }
    chiledelement.appendChild(deletebutton)
    parentElement.appendChild(chiledelement)

        }
    </script>
</body>
</html>