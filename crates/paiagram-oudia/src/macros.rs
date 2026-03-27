macro_rules! wasm_support {
    ($($t:tt)*) => {
        #[derive(Debug, Clone, PartialEq)]
        #[cfg_attr(feature = "serde", derive(::serde::Serialize, ::serde::Deserialize))]
        #[cfg_attr(feature = "wasm", derive(::tsify::Tsify))]
        #[cfg_attr(feature = "wasm", tsify(into_wasm_abi, from_wasm_abi))]
        $($t)*
    };
}
