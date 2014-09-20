MathJax.Hub.Config({
    TeX: {
        Macros: {
            vec: ["\\boldsymbol{#1}",1],
            uvec: ["\\hat{\\boldsymbol{#1}}",1],
            mat: ["\\begin{pmatrix}#1\\end{pmatrix}",1],
            red: ["\\color{red}{\\text{#1}}",1],
            dv:  ["\\frac{\\mathrm{d}}{\\mathrm{d}#1}",1]
        }
    }
});
